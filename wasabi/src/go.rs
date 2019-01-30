use bytes::{as_i32_le, as_i64_le, i32_as_u8_le, i64_as_u8_le, u32_as_u8_le};
use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use js;
use network;
use network::NetLoop;
use rand::{thread_rng, Rng};
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap, VecDeque};
use std::error::Error;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{io, slice, str, thread, time};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::{
    instantiate, ActionOutcome, Compiler, InstantiationError, Namespace, RuntimeValue,
};
use wasmtime_runtime::{Imports, Instance, VMContext, VMFunctionBody, VMMemoryDefinition};

#[derive(Debug, Eq)]
struct Callback {
    time: i64,
    id: i32,
}

impl Ord for Callback {
    fn cmp(&self, other: &Self) -> Ordering {
        self.time.cmp(&other.time)
    }
}
impl PartialOrd for Callback {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Callback {
    fn eq(&self, other: &Self) -> bool {
        self.time == other.time && self.id == other.id
    }
}

#[derive(Debug)]
struct SharedState {
    definition: Option<*mut VMMemoryDefinition>,
    pending_event_ref: i32,
    exited: bool,
    poll: mio::Poll,
    net_loop: NetLoop,
    net_callback_id: i64,
    next_callback_timeout_id: i32,
    callback_heap: BinaryHeap<Callback>,
    callback_map: HashMap<i32, bool>,
    call_queue: VecDeque<i64>,
    js: js::Js,
}

impl SharedState {
    fn new() -> Self {
        Self {
            callback_heap: BinaryHeap::new(),
            callback_map: HashMap::new(),
            definition: None,
            exited: false,
            poll: mio::Poll::new().unwrap(),
            net_loop: NetLoop::new(),
            net_callback_id: 0,
            next_callback_timeout_id: 1,
            pending_event_ref: 0,
            js: js::Js::new(),
            call_queue: VecDeque::new(),
        }
    }
    fn add_pending_event(&mut self, id: i64, args: Vec<(i64, bool)>) {
        println!("Add pending event {:?}", (id, &args));
        let pe = self.js.slab_add(js::Value::Object {
            name: "pending_event",
            values: HashMap::new(),
        });
        self.js.add_object_value(pe, "id", (id, false));
        self.js.add_object(pe, "this");
        self.js.add_array(pe, "args", args);
        self.call_queue.push_back(pe);
    }
}

struct FuncContext {
    vmctx: *mut VMContext,
}
impl FuncContext {
    fn new(vmctx: *mut VMContext) -> Self {
        Self { vmctx }
    }
}

impl ContextHelpers for FuncContext {
    fn shared_state(&self) -> &mut SharedState {
        unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
    }
    fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
        unsafe {
            let memory_def = &*self.definition();
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..end]
        }
    }
}

trait ContextHelpers {
    fn shared_state(&self) -> &mut SharedState;
    fn definition(&self) -> *mut VMMemoryDefinition {
        self.shared_state().definition.unwrap()
    }
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8];
    fn mem_slice(&self, start: usize, end: usize) -> &[u8];
    fn js(&self) -> &mut js::Js {
        &mut self.shared_state().js
    }
    fn reflect_set(&mut self, target: i64, property_key: &'static str, value: i64) {
        self.shared_state()
            .js
            .reflect_set(target, property_key, value)
    }
    fn reflect_get(&self, target: i64, property_key: &'static str) -> Option<(i64, bool)> {
        self.shared_state().js.reflect_get(target, property_key)
    }
    fn reflect_get_index(&self, target: i64, property_key: i64) -> Option<(i64, bool)> {
        self.shared_state()
            .js
            .reflect_get_index(target, property_key)
    }
    fn value_length(&self, target: i64) -> Option<i64> {
        self.shared_state().js.value_length(target)
    }
    fn reflect_apply(
        &self,
        target: i64,
        this_argument: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        let target_name = self.shared_state().js.get_object_name(target).unwrap();
        let this_argument_name = self
            .shared_state()
            .js
            .get_object_name(this_argument)
            .unwrap();

        match (target_name, this_argument_name) {
            ("getTimezoneOffset", "Date") => Some((0, false)),
            ("register", "net_listener") => {
                if let js::Value::Object { values, .. } =
                    self.shared_state().js.slab_get(argument_list[0].0).unwrap()
                {
                    self.shared_state().net_callback_id = values.get("id").unwrap().0;
                }
                Some((0, true))
            }
            ("_makeFuncWrapper", "this") => {
                let wf = self.shared_state().js.slab_add(js::Value::Object {
                    name: "wrappedFunc",
                    values: HashMap::new(),
                });
                // maybe don't create an object here?
                self.shared_state().js.add_object(wf, "this");
                self.shared_state()
                    .js
                    .add_object_value(wf, "id", argument_list[0]);
                Some((wf, true))
            }
            ("getRandomValues", "crypto") => {
                if let js::Value::Memory { address, len } =
                    self.shared_state().js.slab_get(argument_list[0].0).unwrap()
                {
                    thread_rng()
                        .fill(self.mut_mem_slice(*address as usize, (address + len) as usize));
                };
                Some((0, true))
            }
            ("write", "fs") => {
                // [
                //     fd:       (1, false),
                //     buffer:   (33, true),
                //     offset:   (1, true),
                //     len:      (85, false),
                //               (2, true),
                //     callback: (34, true),
                // ];
                if let js::Value::Memory { address, len } =
                    self.shared_state().js.slab_get(argument_list[1].0).unwrap()
                {
                    print!(
                        "{}",
                        str::from_utf8(self._get_bytes(*address as usize, *len as usize)).unwrap()
                    );
                }
                self.shared_state().js.add_array(
                    argument_list[5].0,
                    "args",
                    vec![(2, true), argument_list[3]],
                );
                self.shared_state().call_queue.push_back(argument_list[5].0);
                Some(argument_list[3])
            }
            _ => {
                panic!(
                    "No reflect_apply match on {:?} {:?}",
                    target_name, this_argument_name
                );
            }
        }
    }
    fn reflect_construct(
        &self,
        target: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        self.shared_state()
            .js
            .reflect_construct(target, argument_list)
    }

    fn get_i32(&self, sp: i32) -> i32 {
        let spu = sp as usize;
        as_i32_le(self.mem_slice(spu, spu + 8))
    }
    fn get_i64(&self, sp: i32) -> i64 {
        let spu = sp as usize;
        unsafe {
            let memory_def = &*self.definition();
            as_i64_le(
                &slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8],
            )
        }
    }
    fn get_f64(&self, sp: i32) -> f64 {
        f64::from_bits(self.get_i64(sp) as u64)
    }
    fn set_f64(&self, sp: i32, num: f64) {
        self.set_i64(sp, num.to_bits() as i64);
    }
    fn get_bytes(&self, sp: i32) -> &[u8] {
        let saddr = self.get_i32(sp) as usize;
        let ln = self.get_i32(sp + 8) as usize;
        self._get_bytes(saddr, ln)
    }
    fn _get_bytes(&self, address: usize, ln: usize) -> &[u8] {
        self.mem_slice(address, address + ln)
    }
    fn get_static_string(&self, sp: i32) -> &'static str {
        let key = str::from_utf8(self.get_bytes(sp)).unwrap();
        if key == "AbortController" {
            panic!([
                "\"AbortController\" requested. This likely means ",
                "the default js/wasm roundtripper is being used. Wasabi",
                " doesn't support this, use the wasabi networking libary."
            ]
            .join(""))
        }
        match self.shared_state().js.static_strings.get(&key) {
            Some(v) => v,
            None => {
                panic!("No existing static string matching {:?}", key);
            }
        }
    }

    fn get_string(&self, sp: i32) -> &str {
        str::from_utf8(self.get_bytes(sp)).unwrap()
    }
    fn set_i64(&self, sp: i32, num: i64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&i64_as_u8_le(num));
    }
    fn set_i32(&self, sp: i32, num: i32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&i32_as_u8_le(num));
    }
    fn set_u32(&self, sp: i32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    fn set_bool(&self, addr: i32, value: bool) {
        let val = if value { 1 } else { 0 };
        self.mut_mem_slice(addr as usize, (addr + 1) as usize)
            .clone_from_slice(&[val]);
    }
    fn set_byte_array_array(&self, addr: i32, values: Vec<Vec<u8>>) {
        let mut byte_references = vec![0; values.len() * 4];
        for (i, value) in values.iter().enumerate() {
            let reference = self.store_value_bytes(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&i32_as_u8_le(reference));
        }
        self.set_i32(addr, self.store_value_bytes(byte_references))
    }
    fn set_usize_result(&self, addr: i32, result: io::Result<usize>) {
        match result {
            Ok(value) => {
                self.set_i32(addr, value as i32);
                self.set_bool(addr + 4, true);
            }
            Err(err) => {
                self.set_error(addr, &err);
                self.set_bool(addr + 4, false);
            }
        }
    }

    fn set_error(&self, addr: i32, err: &Error) {
        self.store_string(addr, err.to_string())
    }
    fn store_value_bytes(&self, b: Vec<u8>) -> i32 {
        self.shared_state().js.slab_add(js::Value::Bytes(b)) as i32
    }
    fn store_value(&self, addr: i32, jsv: (i64, bool)) {
        let b = js::store_value(jsv);
        let addru = addr as usize;
        self.mut_mem_slice(addru, addru + 8).copy_from_slice(&b)
    }
    fn store_string(&self, address: i32, val: String) {
        self.set_i32(address, self.store_value_bytes(val.into_bytes()));
    }
    fn load_slice_of_values(&self, address: i32) -> Vec<(i64, bool)> {
        let mut out = Vec::new();
        let array = self.get_i32(address);
        let len = self.get_i32(address + 8);
        for n in 0..len {
            out.push(self.load_value(array + n * 8))
        }
        out
    }
    fn load_value(&self, address: i32) -> (i64, bool) {
        let addru = address as usize;
        js::load_value(&self.mem_slice(addru, addru + 8))
    }
}

fn epoch_ns() -> i64 {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    since_the_epoch.as_secs() as i64 * 1_000_000_000 + i64::from(since_the_epoch.subsec_nanos())
}

extern "C" fn go_debug(_sp: i32) {
    println!("debug")
}

extern "C" fn go_schedule_timeout_event(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let count = fc.get_i64(sp + 8);
    let id = fc.shared_state().next_callback_timeout_id;
    fc.set_i32(sp + 16, id);
    fc.shared_state().next_callback_timeout_id += 1;
    fc.shared_state().callback_heap.push(Callback {
        time: epoch_ns() + count * 1_000_000,
        id,
    });
    fc.shared_state().callback_map.insert(id, true);
}
extern "C" fn go_clear_timeout_event(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    fc.shared_state().callback_map.remove(&id);
}
extern "C" fn go_syscall(_sp: i32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.store_value(
        sp + 24,
        (
            fc.shared_state()
                .js
                .slab_add(js::Value::String(fc.get_string(sp + 8).to_string())),
            true,
        ),
    );
}

extern "C" fn go_js_value_get(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let result = fc
        .reflect_get(fc.load_value(sp + 8).0, &fc.get_static_string(sp + 16))
        .unwrap();
    fc.store_value(sp + 32, result);
}
extern "C" fn go_js_value_set(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // TODO check that return of load_value is actually a ref
    fc.shared_state().js.reflect_set(
        fc.load_value(sp + 8).0,
        fc.get_static_string(sp + 16),
        fc.load_value(sp + 32).0,
    );
}
extern "C" fn go_js_value_index(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.store_value(
        sp + 24,
        fc.reflect_get_index(fc.load_value(sp + 8).0, fc.get_i64(sp + 16))
            .unwrap(),
    );
}
extern "C" fn go_js_value_set_index(_sp: i32) {
    println!("js_value_set_index")
}
extern "C" fn go_js_value_invoke(_sp: i32) {
    println!("js_value_invoke")
}
extern "C" fn go_js_value_call(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    let m = fc.reflect_get(v.0, &fc.get_static_string(sp + 16)).unwrap();
    let args = fc.load_slice_of_values(sp + 32);
    let result = fc.reflect_apply(m.0, v.0, args).unwrap();
    // TODO: catch error and error
    fc.store_value(sp + 56, result);
    fc.set_bool(sp + 64, true);
}
extern "C" fn go_js_value_new(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8).0;
    let args = fc.load_slice_of_values(sp + 16);
    let result = fc.reflect_construct(v, args).unwrap();
    fc.store_value(sp + 40, result);
    fc.set_bool(sp + 48, true);
}
extern "C" fn go_js_value_length(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    fc.set_i64(sp + 16, fc.value_length(v.0).unwrap());
}
extern "C" fn go_js_value_prepare_string(_sp: i32) {
    println!("js_value_prepare_string")
}
extern "C" fn go_js_value_load_string(_sp: i32) {
    println!("js_value_load_string")
}

extern "C" fn go_wasmexit(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let exit_code = fc.get_i32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    fc.shared_state().exited = true;
}

extern "C" fn go_wasmwrite(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    print!("{}", fc.get_string(sp + 16));
}

extern "C" fn go_walltime(sp: i32, vmctx: *mut VMContext) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, since_the_epoch.as_secs() as i64);
    fc.set_i32(sp + 8 + 8, since_the_epoch.subsec_nanos() as i32);
}

extern "C" fn go_nanotime(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, epoch_ns());
}

extern "C" fn go_get_random_data(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_i32(sp + 8);
    let ln = fc.get_i32(sp + 16);
    thread_rng().fill(fc.mut_mem_slice(addr as usize, (addr + ln) as usize));
}

extern "C" fn go_load_bytes(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);

    let b = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b,
        _ => panic!("load_bytes needs bytes"),
    };
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b);
}
extern "C" fn go_prepare_bytes(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);

    let b = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b,
        _ => panic!("load_bytes needs bytes"),
    };
    fc.set_i64(sp + 16, b.len() as i64);
}

extern "C" fn go_listen_tcp(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    match &addr.parse() {
        Ok(addr) => {
            let id = fc.shared_state().net_loop.tcp_listen(addr);
            fc.set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_accept_tcp(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let token = fc.get_i32(sp + 8);
    println!("go_accept_tcp {}", token);
    let id = fc.shared_state().net_loop.tcp_accept(token as usize);
    fc.set_usize_result(sp + 16, id);
}

extern "C" fn go_dial_tcp(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    println!("go_dial_tcp {}", addr);
    match &addr.parse() {
        Ok(addr) => {
            let id = fc.shared_state().net_loop.tcp_connect(addr);
            fc.set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_write_tcp_conn(sp: i32, vmctx: *mut VMContext) {
    println!("go_write_tcp_conn");
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);
    let written = fc.shared_state().net_loop.write_stream(
        id as usize,
        fc.mem_slice(addr as usize, (addr + ln) as usize),
    );
    fc.set_usize_result(sp + 40, written);
}

extern "C" fn go_read_tcp_conn(sp: i32, vmctx: *mut VMContext) {
    println!("go_read_tcp_conn");
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);
    let read = fc.shared_state().net_loop.read_stream(
        id as usize,
        fc.mut_mem_slice(addr as usize, (addr + ln) as usize),
    );
    fc.set_usize_result(sp + 40, read);
}

extern "C" fn go_lookup_ip_addr(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    // TODO handle error
    match resolve_host(&addr) {
        Ok(ips) => {
            fc.set_bool(sp + 24 + 4, true);
            let mut byte_ips: Vec<Vec<u8>> = Vec::new();
            for ip in ips.iter() {
                match ip {
                    IpAddr::V4(ip4) => byte_ips.push(ip4.octets().to_vec()),
                    IpAddr::V6(_) => {} //no IPV6 support
                }
            }
            fc.set_byte_array_array(sp + 24, byte_ips)
        }
        Err(err) => {
            fc.set_bool(sp + 24 + 4, false);
            fc.set_error(sp + 24, &err)
        }
    }
}

fn resolve_host(host: &str) -> Result<Vec<IpAddr>, std::io::Error> {
    (host, 0)
        .to_socket_addrs()
        .map(|iter| iter.map(|socket_address| socket_address.ip()).collect())
}

pub fn instantiate_go() -> Result<Instance, InstantiationError> {
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);

    #[rustfmt::skip]
    let functions = [
        ("debug", go_debug as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.acceptTcp", go_accept_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.dialTcp", go_dial_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.listenTcp", go_listen_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.lookupIPAddr", go_lookup_ip_addr as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.readConn", go_read_tcp_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/net.writeConn", go_write_tcp_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/wasm.loadBytes", go_load_bytes as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/pkg/wasm.prepareBytes", go_prepare_bytes as *const VMFunctionBody ),
        ("runtime.clearTimeoutEvent", go_clear_timeout_event as *const VMFunctionBody),
        ("runtime.getRandomData", go_get_random_data as *const VMFunctionBody),
        ("runtime.nanotime", go_nanotime as *const VMFunctionBody),
        ("runtime.scheduleTimeoutEvent", go_schedule_timeout_event as *const VMFunctionBody),
        ("runtime.walltime", go_walltime as *const VMFunctionBody),
        ("runtime.wasmExit", go_wasmexit as *const VMFunctionBody),
        ("runtime.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("syscall.socket", go_debug as *const VMFunctionBody),
        ("syscall.Syscall", go_syscall as *const VMFunctionBody),
        ("syscall.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("syscall/js.stringVal", go_js_string_val as *const VMFunctionBody),
        ("syscall/js.valueCall", go_js_value_call as *const VMFunctionBody),
        ("syscall/js.valueGet", go_js_value_get as *const VMFunctionBody),
        ("syscall/js.valueIndex", go_js_value_index as *const VMFunctionBody),
        ("syscall/js.valueInvoke", go_js_value_invoke as *const VMFunctionBody),
        ("syscall/js.valueLength", go_js_value_length as *const VMFunctionBody),
        ("syscall/js.valueLoadString", go_js_value_load_string as *const VMFunctionBody),
        ("syscall/js.valueNew", go_js_value_new as *const VMFunctionBody),
        ("syscall/js.valuePrepareString", go_js_value_prepare_string as *const VMFunctionBody),
        ("syscall/js.valueSet", go_js_value_set as *const VMFunctionBody),
        ("syscall/js.valueSetIndex", go_js_value_set_index as *const VMFunctionBody),
        ("syscall/wasm.getRandomData", go_get_random_data as *const VMFunctionBody),
        ("syscall/wasm.loadBytes", go_load_bytes as *const VMFunctionBody),
        ("syscall/wasm.prepareBytes", go_prepare_bytes as *const VMFunctionBody),
    ];

    for func in functions.iter() {
        let sig = module.signatures.push(translate_signature(
            ir::Signature {
                params: vec![ir::AbiParam::new(types::I32)],
                returns: vec![],
                call_conv,
            },
            pointer_type,
        ));
        let func_index = module.functions.push(sig);
        module
            .exports
            .insert(func.0.to_owned(), Export::Function(func_index));
        finished_functions.push(func.1);
    }

    let memory = module.memory_plans.push(MemoryPlan {
        memory: Memory {
            minimum: 16384,
            maximum: None,
            shared: false,
        },
        style: MemoryStyle::Dynamic {},
        offset_guard_size: 65536,
    });
    module
        .exports
        .insert("mem".to_owned(), Export::Memory(memory));

    let imports = Imports::none();
    let data_initializers = Vec::new();
    let signatures = PrimaryMap::new();

    Instance::new(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
        imports,
        &data_initializers,
        signatures.into_boxed_slice(),
        Box::new(SharedState::new()),
    )
}

fn strptr(s: &str, offset: usize, mem: &mut [u8]) -> (usize, usize) {
    let ptr = offset;
    mem[offset..offset + s.len()].copy_from_slice(s.as_bytes());
    mem[offset + s.len()] = 0u8;
    (ptr, offset + s.len() + (8 - (s.len() % 8)))
}

fn load_args_from_mem(args: Vec<String>, mem: &mut [u8]) -> (i32, i32) {
    let mut offset = 4096;
    let argc = args.len() as i32;
    let mut argv_ptrs = Vec::new();
    for arg in &args {
        let (ptr, o) = strptr(arg, offset, mem);
        offset = o;
        argv_ptrs.push(ptr)
    }

    // TODO: envvars

    let out = offset;
    for argv_ptr in &argv_ptrs {
        mem[offset..offset + 4].copy_from_slice(&u32_as_u8_le(*argv_ptr as u32));
        mem[offset + 4..offset + 4 + 4].copy_from_slice(&u32_as_u8_le(0));
        offset += 8;
    }
    (argc, out as i32)
}

fn load_args_from_definition(args: Vec<String>, definition: *mut VMMemoryDefinition) -> (i32, i32) {
    let mut mem = unsafe {
        let memory_def = &*definition;
        &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[0..16384]
    };
    load_args_from_mem(args, &mut mem)
}

pub fn run(args: Vec<String>, compiler: &mut Compiler, data: Vec<u8>) -> Result<(), String> {
    let mut c = Box::new(compiler);
    let mut namespace = Namespace::new();
    let instance = instantiate_go().expect("Instantiate go");
    let go_index = namespace.instance(Some("go"), instance);

    let instantiate_timer = SystemTime::now();
    let mut instance = instantiate(&mut *c, &data, &mut namespace).map_err(|e| e.to_string())?;
    println!(
        "Instantiation time: {:?}",
        instantiate_timer.elapsed().unwrap()
    );

    let definition = match instance.lookup("mem") {
        Some(wasmtime_runtime::Export::Memory {
            definition,
            memory: _memory,
            vmctx: _vmctx,
        }) => definition,
        Some(_) => panic!("exported item is not a linear memory",),
        None => panic!("no memory export found"),
    };

    let index = namespace.instance(Some("main"), instance);
    {
        let instance = &mut namespace.instances[go_index];
        let host_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("not a thing");
        host_state.definition = Some(definition);
    }

    let (argc, argv) = load_args_from_definition(args, definition);
    let mut function_name = "run";
    let mut args = vec![RuntimeValue::I32(argc), RuntimeValue::I32(argv)];
    let invoke_timer = SystemTime::now();
    loop {
        match namespace
            .invoke(&mut *c, index, function_name, &args)
            .map_err(|e| e.to_string())?
        {
            ActionOutcome::Returned { .. } => {}
            ActionOutcome::Trapped { message } => {
                return Err(format!(
                    "Trap from within function {}: {}",
                    function_name, message
                ));
            }
        }
        function_name = "resume";
        args = vec![];
        let instance = &mut namespace.instances[go_index];
        let shared_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("host state is not a SharedState");

        // Stop execution if we've exited
        if shared_state.exited {
            break;
        }

        // Check for events if we have an active listener
        if shared_state.net_loop.is_listening {
            let mut events = Vec::new();

            // If there's nothing to be called, wait for network events
            if shared_state.call_queue.is_empty() {
                // block if there's nothing else to do
                events.push(shared_state.net_loop.recv().unwrap());
            }
            // Regardless of the state of the call stack, try and fetch some
            // events
            while let Ok(event) = shared_state.net_loop.try_recv() {
                events.push(event)
            }
            let mut network_cb_args = Vec::new();
            for event in &events {
                println!("event {:?}", event);
                let ints = network::event_to_ints(event);
                network_cb_args.push((ints.0, false));
                network_cb_args.push((ints.1, false));
            }
            if !network_cb_args.is_empty() {
                // Add the network callback to the call stack
                let ncbid = shared_state.net_callback_id;
                shared_state.add_pending_event(ncbid, network_cb_args);
            }
        }

        // Invoke an event by setting it as the this._pendingEvent
        if !shared_state.call_queue.is_empty() {
            shared_state.js.add_object_value(
                7,
                "_pendingEvent",
                (shared_state.call_queue.pop_front().unwrap(), true),
            );
            continue;
        }

        // If we have a setTimeout style call, sleep
        // TODO: actually make this play nice with other loop behavior
        // If the call_queue has items
        if let Some(callback) = shared_state.callback_heap.pop() {
            let sleep_time = time::Duration::from_nanos((callback.time - epoch_ns()) as u64);
            thread::sleep(sleep_time);
            continue;
        }

        // If we have things to call let the program continue for another loop
        if !shared_state.call_queue.is_empty() {
            continue;
        }

        // If we get this far we've run out of things to do, but the program
        // hasn't exited normally. Set pending event to 0 to trigger a stack
        // dump and exit
        if !shared_state.exited {
            shared_state.exited = true;
            // TODO: fix this it doesn't run as expected
            shared_state.add_pending_event(0, Vec::new());
            continue;
        }

        break;
    }
    println!("Invocation time: {:?}", invoke_timer.elapsed().unwrap());

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::any::Any;

    struct TestVMContext {
        shared_state: Box<dyn Any>,
        mem: Box<dyn Any>,
    }

    struct TestContext {
        vmctx: *mut TestVMContext,
        // place the testcontext here so that it has the same
        // lifetime as the test context?
        #[allow(dead_code)]
        v: TestVMContext,
    }

    impl TestContext {
        fn new(vmctx: *mut TestVMContext, v: TestVMContext) -> Self {
            Self { vmctx, v }
        }
    }
    impl ContextHelpers for TestContext {
        fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
            unsafe { &mut (&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }
        fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
            unsafe { &(&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }

        fn shared_state(&self) -> &mut SharedState {
            unsafe {
                (&mut *self.vmctx)
                    .shared_state
                    .downcast_mut::<SharedState>()
                    .unwrap()
            }
        }
    }

    fn test_context() -> TestContext {
        let ss = SharedState::new();
        let mem: Vec<u8> = vec![0; 100];
        let mut vmc = TestVMContext {
            shared_state: Box::new(ss),
            mem: Box::new(mem),
        };
        let tc = TestContext::new(&mut vmc as *mut TestVMContext, vmc);
        tc
    }

    #[test]
    fn test_args_and_ev() {
        let mut mem: Vec<u8> = vec![0; 10000];
        let args = vec![
            "/var/folders/nn/q8p1tdps0jlfnll5nc8ydmwc0000gn/T/go-build020729976/b001/exe/main"
                .to_string(),
        ];
        let (argc, argv) = load_args_from_mem(args, &mut mem);
        let answer: Vec<u8> = vec![
            47, 118, 97, 114, 47, 102, 111, 108, 100, 101, 114, 115, 47, 110, 110, 47, 113, 56,
            112, 49, 116, 100, 112, 115, 48, 106, 108, 102, 110, 108, 108, 53, 110, 99, 56, 121,
            100, 109, 119, 99, 48, 48, 48, 48, 103, 110, 47, 84, 47, 103, 111, 45, 98, 117, 105,
            108, 100, 48, 50, 48, 55, 50, 57, 57, 55, 54, 47, 98, 48, 48, 49, 47, 101, 120, 101,
            47, 109, 97, 105, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0,
        ];
        assert_eq!(&mem[4096..4192], &answer[..]);
        assert_eq!(argc, 1);
        assert_eq!(argv, 4184);
    }

    #[test]
    fn i32_get_and_set() {
        let tc = test_context();
        tc.set_i32(0, 2147483647);
        assert_eq!(2147483647, tc.get_i32(0));
        tc.set_i32(0, -2147483647);
        assert_eq!(-2147483647, tc.get_i32(0));
    }

}
