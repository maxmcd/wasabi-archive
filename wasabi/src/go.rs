use bytes::{as_i32_le, as_i64_le, i32_as_u8_le, i64_as_u8_le, u32_as_u8_le};
use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use failure::{Error, Fail};
use js;
use network;
use network::{addr_to_bytes, NetLoop};
use rand::{thread_rng, Rng};
use std::cell::RefCell;
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap, VecDeque};
use std::net;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{io, slice, str, thread, time};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::{ActionOutcome, Compiler, Context, InstantiationError, RuntimeValue};
use wasmtime_runtime::{Imports, InstanceHandle, VMContext, VMFunctionBody, VMMemoryDefinition};

#[derive(Debug, Eq)]
struct Callback {
    time: i64,
    id: i32,
}

impl Callback {
    fn time_until_called(&self) -> time::Duration {
        time::Duration::from_nanos((self.time - epoch_ns()).abs() as u64)
    }
    fn sleep_until_called(&self) {
        thread::sleep(self.time_until_called());
    }
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
    next_timeout_id: i32,
    timeout_heap: BinaryHeap<Callback>,
    timeout_map: HashMap<i32, bool>,
    call_queue: VecDeque<i64>,
    js: js::Js,
}

impl SharedState {
    fn new() -> Self {
        Self {
            timeout_heap: BinaryHeap::new(),
            timeout_map: HashMap::new(),
            definition: None,
            exited: false,
            poll: mio::Poll::new().unwrap(),
            net_loop: NetLoop::new(),
            net_callback_id: 0,
            next_timeout_id: 1,
            pending_event_ref: 0,
            js: js::Js::new().unwrap(),
            call_queue: VecDeque::new(),
        }
    }
    fn recv_net_events(&mut self) -> Option<Vec<mio::event::Event>> {
        let mut events = Vec::new();

        // If there's nothing at all to be called, wait for network events
        if self.call_queue.is_empty() && self.timeout_heap.is_empty() {
            events.push(self.net_loop.recv().unwrap());

        // If the timeout heap has candidates only wait on the recv until
        // the next timeout
        } else if self.call_queue.is_empty() && !self.timeout_heap.is_empty() {
            if let Ok(event) = self
                .net_loop
                .recv_timeout(self.timeout_heap.peek().unwrap().time_until_called())
            {
                events.push(event)
            }
        }

        // Run a try_recv loop to drain events regardless of how we got here
        while let Ok(event) = self.net_loop.try_recv() {
            events.push(event)
        }

        if events.is_empty() {
            None
        } else {
            Some(events)
        }
    }
    fn check_expired_timeouts(&mut self) -> bool {
        let mut should_return = false;
        if let Some(callback) = self.timeout_heap.peek() {
            if callback.time < epoch_ns() {
                should_return = true;
            }
        }
        if should_return {
            self.timeout_heap.pop();
            should_return
        } else {
            should_return
        }
    }
    fn add_pending_event(&mut self, id: i64, args: Vec<(i64, bool)>) {
        // TODO: return result
        let pe = self.js.slab_add(js::Value::Object {
            name: "pending_event",
            values: HashMap::new(),
        });
        self.js.add_object_value(pe, "id", (id, false)).unwrap();
        self.js.add_object_value(pe, "result", (2, true)).unwrap();
        self.js.add_object(pe, "this").unwrap();
        self.js.add_array(pe, "args", args).unwrap();
        self.call_queue.push_back(pe);
    }
    fn process_event_loop(&mut self) -> Result<bool, Error> {
        // Stop execution if we've exited
        if self.exited {
            return Ok(true);
        }

        // Check for events if we have an active listener
        if self.net_loop.is_listening {
            if let Some(events) = self.recv_net_events() {
                let mut network_cb_args = Vec::new();
                for event in &events {
                    let ints = network::event_to_ints(event);
                    network_cb_args.push((ints.0, false));
                    network_cb_args.push((ints.1, false));
                }
                // Add the network callback to the call stack
                let ncbid = self.net_callback_id;
                self.add_pending_event(ncbid, network_cb_args);
            }
        }

        // Check if any timeouts have expired.
        if self.check_expired_timeouts() {
            return Ok(false);
        }

        // Invoke an event by setting it as the this._pendingEvent
        if !self.call_queue.is_empty() {
            self.js
                .add_object_value(
                    7,
                    "_pendingEvent",
                    (self.call_queue.pop_front().unwrap(), true),
                )
                .unwrap();
            return Ok(false);
        }

        // See if we can wait for a callback
        if let Some(callback) = self.timeout_heap.pop() {
            callback.sleep_until_called();
            return Ok(false);
        }

        // If we get this far we've run out of things to do, but the program
        // hasn't exited normally. Set pending event to 0 to trigger a stack
        // dump and exit
        if !self.exited {
            self.exited = true;
            // TODO: fix this it doesn't run as expected
            // TODO: seems to run as expected... write a test
            self.add_pending_event(0, Vec::new());
            return Ok(false);
        }

        Ok(true)
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
    fn shared_state_mut(&mut self) -> &mut SharedState {
        unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }
    fn shared_state(&self) -> &SharedState {
        &*unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }

    fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8] {
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
    fn shared_state(&self) -> &SharedState;
    fn shared_state_mut(&mut self) -> &mut SharedState;
    fn definition(&self) -> *mut VMMemoryDefinition {
        self.shared_state().definition.unwrap()
    }
    fn mem(&self) -> (*mut u8, usize) {
        let memory_def = unsafe { &*self.definition() };
        (memory_def.base, memory_def.current_length)
    }
    fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8];
    fn mem_slice(&self, start: usize, end: usize) -> &[u8];
    fn js(&self) -> &js::Js {
        &self.shared_state().js
    }
    fn js_mut(&mut self) -> &mut js::Js {
        &mut self.shared_state_mut().js
    }
    fn reflect_set(
        &mut self,
        target: i64,
        property_key: &'static str,
        value: i64,
    ) -> Result<(), Error> {
        self.shared_state_mut()
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
    // TODO: return Result
    fn reflect_apply(
        &mut self,
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
                let values = {
                    match self.shared_state().js.slab_get(argument_list[0].0).unwrap() {
                        js::Value::Object { values, .. } => values.get("id").unwrap().0,
                        _ => {
                            return None;
                        }
                    }
                };
                self.shared_state_mut().net_callback_id = values;
                Some((0, true))
            }
            ("_makeFuncWrapper", "this") => {
                let mut js = self.js_mut();
                let wf = js.slab_add(js::Value::Object {
                    name: "wrappedFunc",
                    values: HashMap::new(),
                });
                // maybe don't create an object here?
                js.add_object(wf, "this").unwrap();
                js.add_object_value(wf, "id", argument_list[0]).unwrap();
                Some((wf, true))
            }
            ("getRandomValues", "crypto") => {
                let (address, len) = {
                    match self.js().slab_get(argument_list[0].0).unwrap() {
                        js::Value::Memory { address, len } => (*address as usize, *len as usize),
                        _ => {
                            return None;
                        }
                    }
                };
                thread_rng().fill(self.mut_mem_slice(address, address + len));
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
                let (address, len) = {
                    match self.js().slab_get(argument_list[1].0).unwrap() {
                        js::Value::Memory { address, len } => (*address as usize, *len as usize),
                        _ => {
                            return None;
                        }
                    }
                };
                print!("{}", str::from_utf8(self._get_bytes(address, len)).unwrap());
                self.js_mut()
                    .add_array(
                        argument_list[5].0,
                        "args",
                        vec![(2, true), argument_list[3]],
                    )
                    .unwrap();
                self.js_mut()
                    .add_object_value(argument_list[5].0, "result", (2, true))
                    .unwrap();
                self.shared_state_mut()
                    .call_queue
                    .push_back(argument_list[5].0);
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
        &mut self,
        target: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        self.shared_state_mut()
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
    fn set_f64(&mut self, sp: i32, num: f64) {
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
    fn set_i64(&mut self, sp: i32, num: i64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&i64_as_u8_le(num));
    }
    fn set_i32(&mut self, sp: i32, num: i32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&i32_as_u8_le(num));
    }
    fn set_u32(&mut self, sp: i32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    fn set_bool(&mut self, addr: i32, value: bool) {
        let val = if value { 1 } else { 0 };
        self.mut_mem_slice(addr as usize, (addr + 1) as usize)
            .clone_from_slice(&[val]);
    }
    fn set_byte_array_array(&mut self, addr: i32, values: Vec<Vec<u8>>) {
        let mut byte_references = vec![0; values.len() * 4];
        for (i, value) in values.iter().enumerate() {
            let reference = self.store_value_bytes(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&i32_as_u8_le(reference));
        }
        let reference = self.store_value_bytes(byte_references);
        self.set_i32(addr, reference);
    }
    fn set_usize_result(&mut self, addr: i32, result: io::Result<usize>) {
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

    fn set_error(&mut self, addr: i32, err: &Fail) {
        self.store_string(addr, err.to_string())
    }
    fn store_value_bytes(&mut self, b: Vec<u8>) -> i32 {
        self.shared_state_mut().js.slab_add(js::Value::Bytes(b)) as i32
    }
    fn store_value(&mut self, addr: i32, jsv: (i64, bool)) {
        let b = js::store_value(jsv);
        let addru = addr as usize;
        self.mut_mem_slice(addru, addru + 8).copy_from_slice(&b)
    }
    fn store_string(&mut self, address: i32, val: String) {
        let reference = self.store_value_bytes(val.into_bytes());
        self.set_i32(address, reference);
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

extern "C" fn go_schedule_timeout_event(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let count = fc.get_i64(sp + 8);
    let id = fc.shared_state().next_timeout_id;
    fc.set_i32(sp + 16, id);
    fc.shared_state_mut().next_timeout_id += 1;
    fc.shared_state_mut().timeout_heap.push(Callback {
        time: epoch_ns() + count * 1_000_000,
        id,
    });
    fc.shared_state_mut().timeout_map.insert(id, true);
}
extern "C" fn go_clear_timeout_event(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    fc.shared_state_mut().timeout_map.remove(&id);
}
extern "C" fn go_syscall(_sp: i32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let string = js::Value::String(fc.get_string(sp + 8).to_string());
    let reference = fc.shared_state_mut().js.slab_add(string);
    fc.store_value(sp + 24, (reference, true));
}

extern "C" fn go_js_value_get(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let result = fc
        .reflect_get(fc.load_value(sp + 8).0, &fc.get_static_string(sp + 16))
        .unwrap();
    fc.store_value(sp + 32, result);
}
extern "C" fn go_js_value_set(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let target = fc.load_value(sp + 8).0;
    let property_key = fc.get_static_string(sp + 16);
    let value = fc.load_value(sp + 32).0;
    if let Err(err) = fc
        .shared_state_mut()
        .js
        .reflect_set(target, property_key, value)
    {
        fc.set_error(sp, err.as_fail())
    };
}
extern "C" fn go_js_value_index(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let target = fc.load_value(sp + 8).0;
    let property_key = fc.get_i64(sp + 16);
    let jsv = fc.reflect_get_index(target, property_key).unwrap();
    fc.store_value(sp + 24, jsv);
}
extern "C" fn go_js_value_set_index(_sp: i32) {
    println!("js_value_set_index")
}
extern "C" fn go_js_value_invoke(_sp: i32) {
    println!("js_value_invoke")
}
extern "C" fn go_js_value_call(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    let m = fc.reflect_get(v.0, &fc.get_static_string(sp + 16)).unwrap();
    let args = fc.load_slice_of_values(sp + 32);
    let result = fc.reflect_apply(m.0, v.0, args).unwrap();
    // TODO: catch error and error
    fc.store_value(sp + 56, result);
    fc.set_bool(sp + 64, true);
}
extern "C" fn go_js_value_new(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8).0;
    let args = fc.load_slice_of_values(sp + 16);
    let result = fc.reflect_construct(v, args).unwrap();
    fc.store_value(sp + 40, result);
    fc.set_bool(sp + 48, true);
}
extern "C" fn go_js_value_length(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    let num = fc.value_length(v.0).unwrap();
    fc.set_i64(sp + 16, num);
}
extern "C" fn go_js_value_prepare_string(_sp: i32) {
    println!("js_value_prepare_string")
}
extern "C" fn go_js_value_load_string(_sp: i32) {
    println!("js_value_load_string")
}

extern "C" fn go_wasmexit(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let exit_code = fc.get_i32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    fc.shared_state_mut().exited = true;
}

extern "C" fn go_wasmwrite(vmctx: *mut VMContext, sp: i32) {
    let fc = FuncContext::new(vmctx);
    print!("{}", fc.get_string(sp + 16));
}

extern "C" fn go_walltime(vmctx: *mut VMContext, sp: i32) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let mut fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, since_the_epoch.as_secs() as i64);
    fc.set_i32(sp + 8 + 8, since_the_epoch.subsec_nanos() as i32);
}

extern "C" fn go_nanotime(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, epoch_ns());
}

extern "C" fn go_get_random_data(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.get_i32(sp + 8);
    let ln = fc.get_i32(sp + 16);
    thread_rng().fill(fc.mut_mem_slice(addr as usize, (addr + ln) as usize));
}

extern "C" fn go_load_bytes(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);

    let b = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b.clone(), // TODO: extra clone here to get around borrow checker
        _ => panic!("load_bytes needs bytes"),
    };
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b);
}
extern "C" fn go_prepare_bytes(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);

    let len = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b.len(),
        _ => panic!("load_bytes needs bytes"),
    };
    fc.set_i64(sp + 16, len as i64);
}

extern "C" fn go_listen_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8).to_owned(); // TODO errant allocation for the borrow checker
    match &addr.parse() {
        Ok(addr) => {
            let id = fc.shared_state_mut().net_loop.tcp_listen(addr);
            fc.set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_accept_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let token = fc.get_i32(sp + 8);
    let id = fc.shared_state_mut().net_loop.tcp_accept(token as usize);
    fc.set_usize_result(sp + 16, id);
}

extern "C" fn go_dial_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8).to_owned();
    match &addr.parse() {
        Ok(addr) => {
            let id = fc.shared_state_mut().net_loop.tcp_connect(addr);
            fc.set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_shutdown_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let how = fc.get_i32(sp + 8 + 4);
    // 1 read
    // 2 write
    // 3 both
    let sd = match how {
        1 => net::Shutdown::Read,
        2 => net::Shutdown::Write,
        3 => net::Shutdown::Both,
        _ => panic!("Incorrect value for shutdown {:?}", how),
    };
    if let Err(err) = fc.shared_state_mut().net_loop.shutdown(id as usize, sd) {
        fc.set_error(sp + 16, &err);
        fc.set_bool(sp + 16 + 4, false)
    } else {
        fc.set_bool(sp + 16 + 4, true)
    }
}

extern "C" fn go_write_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);
    let written = fc.shared_state().net_loop.write_stream(
        id as usize,
        fc.mem_slice(addr as usize, (addr + ln) as usize),
    );
    fc.set_usize_result(sp + 40, written);
}

extern "C" fn go_net_get_error(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    match fc.shared_state_mut().net_loop.get_error(id as usize) {
        Ok(e) => {
            if let Some(e) = e {
                fc.set_error(sp + 16, &e);
                fc.set_bool(sp + 16 + 4, true);
            } else {
                fc.set_bool(sp + 16 + 4, false);
            }
        }
        Err(err) => {
            fc.set_error(sp + 16, &err);
            fc.set_bool(sp + 16 + 4, true);
        }
    }
}

extern "C" fn go_read_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let start = fc.get_i32(sp + 16);
    let end = fc.get_i32(sp + 24) + start;
    // TODO Instead of pulling out addr and len and casting the memory inline
    // let's look into getting mut_mem without tying the lifetime to fc
    let (addr, len) = fc.mem();
    let mem = unsafe { &mut slice::from_raw_parts_mut(addr, len)[start as usize..end as usize] };
    let read = fc.shared_state().net_loop.read_stream(id as usize, mem);
    fc.set_usize_result(sp + 40, read);
}

extern "C" fn go_close_listener_or_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    // todo, pass error value

    if let Err(err) = fc.shared_state_mut().net_loop.close(id as usize) {
        fc.set_error(sp + 16, &err);
        fc.set_bool(sp + 16 + 4, false);
    } else {
        fc.set_bool(sp + 16 + 4, true);
    }
}

extern "C" fn go_lookup_ip_addr(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8).to_owned();
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
            fc.set_byte_array_array(sp + 24, byte_ips);
        }
        Err(err) => {
            fc.set_error(sp + 24, &err);
            fc.set_bool(sp + 24 + 4, false);
        }
    }
}

extern "C" fn go_lookup_port(vmctx: *mut VMContext, sp: i32) {
    let fc = FuncContext::new(vmctx);
    let network = fc.get_string(sp + 8).to_owned();
    println!("{:?}", network);
    let service = fc.get_string(sp + 8 + 16).to_owned();
    println!("{:?}", service);
    println!("{:?}", format!(":{}", service));
    let addrs = "0.0.0.0:0".to_socket_addrs();
    println!("{:?}", addrs);
}

extern "C" fn go_local_addr(vmctx: *mut VMContext, sp: i32) {
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let start = fc.get_i32(sp + 16);
    let end = fc.get_i32(sp + 24) + start;
    let (addr, len) = fc.mem();
    let mem = unsafe { &mut slice::from_raw_parts_mut(addr, len)[start as usize..end as usize] };
    let addr = fc.shared_state().net_loop.local_addr(id as usize).unwrap();
    addr_to_bytes(addr, mem).unwrap();
}

extern "C" fn go_remote_addr(vmctx: *mut VMContext, sp: i32) {
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let start = fc.get_i32(sp + 16);
    let end = fc.get_i32(sp + 24) + start;
    let (addr, len) = fc.mem();
    let mem = unsafe { &mut slice::from_raw_parts_mut(addr, len)[start as usize..end as usize] };
    let addr = fc.shared_state().net_loop.peer_addr(id as usize).unwrap();
    addr_to_bytes(addr, mem).unwrap();
}

fn resolve_host(host: &str) -> Result<Vec<IpAddr>, std::io::Error> {
    (host, 0)
        .to_socket_addrs()
        .map(|iter| iter.map(|socket_address| socket_address.ip()).collect())
}

pub fn instantiate_go() -> Result<InstanceHandle, InstantiationError> {
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);

    #[rustfmt::skip]
    let functions = [
        ("debug", go_debug as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.acceptTcp", go_accept_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.closeConn", go_close_listener_or_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.closeListener", go_close_listener_or_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.dialTcp", go_dial_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.getError", go_net_get_error as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.listenTCP", go_listen_tcp as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.localAddr", go_local_addr as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.lookupIP", go_lookup_ip_addr as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.lookupPort", go_lookup_port as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.readConn", go_read_tcp_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.remoteAddr", go_remote_addr as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.shutdownConn", go_shutdown_tcp_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/net.writeConn", go_write_tcp_conn as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/wasm.loadBytes", go_load_bytes as *const VMFunctionBody),
        ("github.com/maxmcd/wasabi/internal/wasm.prepareBytes", go_prepare_bytes as *const VMFunctionBody ),
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
        ("syscall/js.valueInstanceOf", go_debug as *const VMFunctionBody),
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

    InstanceHandle::new(
        Rc::new(module),
        Rc::new(RefCell::new(HashMap::new())),
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

pub fn run(args: Vec<String>, compiler: Compiler, data: Vec<u8>) -> Result<(), String> {
    let c = Box::new(compiler);
    let mut context = Context::new(c);
    let instance = instantiate_go().expect("Instantiate go");
    context.name_instance("go".to_string(), instance);

    let instantiate_timer = SystemTime::now();
    let mut instance = context
        .instantiate_module(Some("main".to_string()), &data)
        .map_err(|e| e.to_string())?;
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

    {
        let instance = &mut context.get_instance(&"go").unwrap();
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
        match context
            .invoke_named("main", function_name, &args)
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
        let instance = &mut context.get_instance(&"go").unwrap();
        let shared_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("host state is not a SharedState");

        let should_break = shared_state.process_event_loop().unwrap();
        if should_break {
            break;
        }
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
        fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8] {
            unsafe { &mut (&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }
        fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
            unsafe { &(&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }

        fn shared_state_mut(&mut self) -> &mut SharedState {
            unsafe {
                (&mut *self.vmctx)
                    .shared_state
                    .downcast_mut::<SharedState>()
                    .unwrap()
            }
        }
        fn shared_state(&self) -> &SharedState {
            &*unsafe {
                (&mut *self.vmctx)
                    .shared_state
                    .downcast_mut::<SharedState>()
                    .unwrap()
            }
        }
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
        let ss = SharedState::new();
        let mem: Vec<u8> = vec![0; 100];
        let mut vmc = TestVMContext {
            shared_state: Box::new(ss),
            mem: Box::new(mem),
        };
        let mut tc = TestContext::new(&mut vmc as *mut TestVMContext, vmc);
        tc.set_i32(0, 2147483647);
        assert_eq!(2147483647, tc.get_i32(0));
        tc.set_i32(0, -2147483647);
        assert_eq!(-2147483647, tc.get_i32(0));
    }

    #[test]
    fn test_event_loop_empty() {
        let mut ss = SharedState::new();

        // no events so the program adds a pending event with id 0
        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, false);
        assert_eq!(ss.call_queue.len(), 1);
        let reference = ss.call_queue.pop_front().unwrap();

        if let js::Value::Object { name, values } = ss.js.slab_get(reference).unwrap() {
            assert_eq!(name, &"pending_event");
            assert_eq!(values["id"].0, 0);
        } else {
            panic!("ref should be an object");
        }

        // now we're exited, so it should break
        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, true);
    }

    #[test]
    fn test_event_loop_only_callback() {
        let mut ss = SharedState::new();
        ss.net_loop.is_listening = true;

        let ms = 0;
        let id = 1;
        ss.timeout_heap.push(Callback {
            time: epoch_ns() + ms * 1_000_000,
            id,
        });

        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, false);
        assert!(ss.timeout_heap.is_empty());

        let ms = 2;
        let id = 1;
        ss.timeout_heap.push(Callback {
            time: epoch_ns() + ms * 1_000_000,
            id,
        });

        let timeout_timer = SystemTime::now();
        let should_break = ss.process_event_loop().unwrap();
        assert!(timeout_timer.elapsed().unwrap() > time::Duration::from_millis(ms as u64));
        assert_eq!(should_break, false);
        assert!(ss.timeout_heap.is_empty());
    }

}
