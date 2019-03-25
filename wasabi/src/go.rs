use bytes::u32_as_u8_le;
use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use failure::Error;
use js;
use mem::{Actions, Mem};
use rand::{thread_rng, Rng};
use shared_state::SharedState;
use std::cell::RefCell;
use std::collections::HashMap;
use std::net;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{slice, str};
use target_lexicon::HOST;
use util::epoch_ns;
use wasabi_io::addr_to_bytes;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::{ActionOutcome, Compiler, Context, InstantiationError, RuntimeValue};
use wasmtime_runtime::{Imports, InstanceHandle, VMContext, VMFunctionBody, VMMemoryDefinition};

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
}

trait ContextHelpers {
    fn shared_state(&self) -> &SharedState;
    fn shared_state_mut(&mut self) -> &mut SharedState;
    // fn mem(&self) -> (*mut u8, usize) {
    //     let memory_def = unsafe { &*self.definition() };
    //     (memory_def.base, memory_def.current_length)
    // }
    fn mem(&self) -> &Mem {
        &self.shared_state().mem
    }
    fn mem_mut(&mut self) -> &mut Mem {
        &mut self.shared_state_mut().mem
    }
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
        self.js_mut().reflect_set(target, property_key, value)
    }
    fn reflect_get(&self, target: i64, property_key: &'static str) -> Option<(i64, bool)> {
        self.js().reflect_get(target, property_key)
    }
    fn reflect_get_index(&self, target: i64, property_key: i64) -> Option<(i64, bool)> {
        self.js().reflect_get_index(target, property_key)
    }
    fn value_length(&self, target: i64) -> Option<i64> {
        self.js().value_length(target)
    }
    // TODO: return Result
    fn reflect_apply(
        &mut self,
        target: i64,
        this_argument: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        let target_name = self.js().get_object_name(target).unwrap();
        let this_argument_name = self.js().get_object_name(this_argument).unwrap();
        match (target_name, this_argument_name) {
            ("getTimezoneOffset", "Date") => Some((0, false)),
            ("register", "net_listener") => {
                let values = {
                    match self.js().slab_get(argument_list[0].0).unwrap() {
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
                thread_rng().fill(
                    self.shared_state_mut()
                        .mem
                        .mut_mem_slice(address, address + len),
                );
                Some((0, true))
            }
            ("lookup_ip", "wasabi") => {
                // host, callback
                // [(59, true), (60, true)]
                let value = {
                    match self.js().slab_get(argument_list[0].0).unwrap() {
                        js::Value::String(s) => (s.to_owned()),
                        _ => {
                            return None;
                        }
                    }
                };
                self.shared_state_mut()
                    .net_loop
                    .lookup_ip(argument_list[1].0, &value);
                Some(argument_list[1])
            }
            ("isDirectory", "fstat") => self.js().reflect_get(this_argument, "is_dir"),
            ("fstat", "fs") => {
                // fd          callback
                // [(1, true), (42, true)]
                self.shared_state_mut().net_loop.fs_metadata(
                    argument_list[1].0,
                    js::int_from_value(argument_list[0]) as usize,
                );
                Some((2, true))
            }
            ("read", "fs") => {
                // [
                //     (1,   true), fd
                //     (48,  true), buffer
                //     (1,   true), offset
                //     (512, false), length
                //     (2,   true), position
                //     (49,  true), callback
                // ];

                let (address, _) = {
                    match self.js().slab_get(argument_list[1].0).unwrap() {
                        js::Value::Memory { address, len } => (*address as usize, *len as usize),
                        _ => {
                            return None;
                        }
                    }
                };
                self.shared_state_mut().net_loop.fs_read(
                    argument_list[5].0,
                    js::int_from_value(argument_list[0]) as usize,
                    address,
                    js::int_from_value(argument_list[3]) as usize,
                    std::io::SeekFrom::Current(0),
                );
                Some((2, true))
            }
            ("open", "fs") => {
                let value = {
                    match self.js().slab_get(argument_list[0].0).unwrap() {
                        js::Value::String(s) => (s.to_owned()),
                        _ => {
                            return None;
                        }
                    }
                };
                self.shared_state_mut().net_loop.fs_open(
                    argument_list[3].0,
                    value,
                    js::int_from_value(argument_list[1]),
                    js::int_from_value(argument_list[2]),
                );
                // [(55, true), (1, true), (1, true), (53, true)
                Some((2, true))
            }
            ("stat", "fs") => {
                // [
                //     path:       (35, false),
                //     callback?:   (33, true),
                let value = {
                    match self.js().slab_get(argument_list[0].0).unwrap() {
                        js::Value::String(s) => (s.to_owned()),
                        _ => {
                            return None;
                        }
                    }
                };
                // let (address, len) = {
                //     match self.js().slab_get(argument_list[1].0).unwrap() {
                //         js::Value::Memory { address, len } => (*address as usize, *len as usize),
                //         _ => {
                //             return None;
                //         }
                //     }
                // };
                println!("{:?} {:?}", argument_list, value);
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
                let to_print = self.mem()._get_bytes(address, len).to_vec();
                self.shared_state_mut()
                    .net_loop
                    .stdout(argument_list[5].0, to_print);
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
        self.js_mut().reflect_construct(target, argument_list)
    }
    fn get_static_string(&self, sp: i32) -> &'static str {
        let key = str::from_utf8(self.mem().get_bytes(sp)).unwrap();
        if key == "AbortController" {
            panic!([
                "\"AbortController\" requested. This likely means ",
                "the default js/wasm roundtripper is being used. Wasabi",
                " doesn't support this, use the wasabi networking libary."
            ]
            .join(""))
        }
        match self.js().static_strings.get(&key) {
            Some(v) => v,
            None => {
                panic!("No existing static string matching {:?}", key);
            }
        }
    }
}

extern "C" fn go_debug(_sp: i32) {
    println!("debug")
}

extern "C" fn go_schedule_timeout_event(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let count = fc.mem().get_i64(sp + 8);
    let id = fc.shared_state_mut().timeout_heap.add(count);
    fc.mem_mut().set_i32(sp + 16, id);
}

extern "C" fn go_clear_timeout_event(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    fc.shared_state_mut().timeout_heap.remove(id);
}

extern "C" fn go_syscall(_sp: i32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let string = js::Value::String(fc.mem().get_string(sp + 8).to_string());
    let reference = fc.js_mut().slab_add(string);
    fc.shared_state_mut()
        .store_value(sp + 24, (reference, true));
}

extern "C" fn go_js_value_get(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let result = fc
        .reflect_get(
            fc.shared_state().load_value(sp + 8).0,
            &fc.get_static_string(sp + 16),
        )
        .unwrap();
    fc.shared_state_mut().store_value(sp + 32, result);
}

extern "C" fn go_js_value_set(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let target = fc.shared_state().load_value(sp + 8).0;
    let property_key = fc.get_static_string(sp + 16);
    let value = fc.shared_state().load_value(sp + 32).0;
    if let Err(err) = fc
        .shared_state_mut()
        .js
        .reflect_set(target, property_key, value)
    {
        fc.shared_state_mut().set_error(sp, &err)
    };
}

extern "C" fn go_js_value_index(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let target = fc.shared_state().load_value(sp + 8).0;
    let property_key = fc.mem().get_i64(sp + 16);
    let jsv = fc.reflect_get_index(target, property_key).unwrap();
    fc.shared_state_mut().store_value(sp + 24, jsv);
}

extern "C" fn go_js_value_set_index(_sp: i32) {
    println!("js_value_set_index")
}

extern "C" fn go_js_value_invoke(_sp: i32) {
    println!("js_value_invoke")
}

extern "C" fn go_js_value_call(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.shared_state().load_value(sp + 8);
    let m = fc.reflect_get(v.0, &fc.get_static_string(sp + 16)).unwrap();
    let args = fc.shared_state().load_slice_of_values(sp + 32);
    let result = fc.reflect_apply(m.0, v.0, args).unwrap();
    // TODO: catch error and error
    fc.shared_state_mut().store_value(sp + 56, result);
    fc.mem_mut().set_bool(sp + 64, true);
}

extern "C" fn go_js_value_new(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.shared_state().load_value(sp + 8).0;
    let args = fc.shared_state().load_slice_of_values(sp + 16);
    let result = fc.reflect_construct(v, args).unwrap();
    fc.shared_state_mut().store_value(sp + 40, result);
    fc.mem_mut().set_bool(sp + 48, true);
}

extern "C" fn go_js_value_length(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let v = fc.shared_state().load_value(sp + 8);
    let num = fc.value_length(v.0).unwrap();
    fc.mem_mut().set_i64(sp + 16, num);
}

extern "C" fn go_js_value_prepare_string(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.mem().get_i32(sp + 8);

    let len = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::String(ref b) => b.len(),
        _ => panic!("load_string needs string"),
    };
    // this is a little different from our prepare_bytes because we
    // don't pass back the reference
    fc.mem_mut().set_i64(sp + 16, i64::from(reference));
    fc.mem_mut().set_i64(sp + 16 + 8, len as i64);
}

extern "C" fn go_js_value_load_string(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.mem().get_i32(sp + 8);
    let addr = fc.mem().get_i32(sp + 16);
    let ln = fc.mem().get_i32(sp + 24);
    let ss = fc.shared_state_mut();
    let thing = ss.js.slab_get(i64::from(reference)).unwrap();
    let b = match thing {
        js::Value::String(ref b) => b,
        _ => panic!("load_string needs string"),
    };
    ss.mem
        .mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b.as_bytes());
}

extern "C" fn go_wasmexit(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let exit_code = fc.mem().get_i32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    fc.shared_state_mut().exited = true;
}

extern "C" fn go_wasmwrite(vmctx: *mut VMContext, sp: i32) {
    let fc = FuncContext::new(vmctx);
    print!("{}", fc.mem().get_string(sp + 16));
}

extern "C" fn go_walltime(vmctx: *mut VMContext, sp: i32) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let mut fc = FuncContext::new(vmctx);
    fc.mem_mut()
        .set_i64(sp + 8, since_the_epoch.as_secs() as i64);
    fc.mem_mut()
        .set_i32(sp + 8 + 8, since_the_epoch.subsec_nanos() as i32);
}

extern "C" fn go_nanotime(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    fc.mem_mut().set_i64(sp + 8, epoch_ns());
}

extern "C" fn go_get_random_data(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.mem().get_i32(sp + 8);
    let ln = fc.mem().get_i32(sp + 16);
    thread_rng().fill(
        fc.shared_state_mut()
            .mem
            .mut_mem_slice(addr as usize, (addr + ln) as usize),
    );
}

extern "C" fn go_load_bytes(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.mem().get_i32(sp + 8);
    let addr = fc.mem().get_i32(sp + 16);
    let ln = fc.mem().get_i32(sp + 24);
    let ss = fc.shared_state_mut();
    let b = match ss.js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b,
        _ => panic!("load_bytes needs bytes"),
    };
    ss.mem
        .mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b);
}

extern "C" fn go_prepare_bytes(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let reference = fc.mem().get_i32(sp + 8);

    let len = match fc.shared_state().js.slab_get(i64::from(reference)).unwrap() {
        js::Value::Bytes(ref b) => b.len(),
        _ => panic!("load_bytes needs bytes"),
    };
    fc.mem_mut().set_i64(sp + 16, len as i64);
}

extern "C" fn go_listen_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.mem().get_string(sp + 8).to_owned(); // TODO errant allocation for the borrow checker
    match &addr
        .parse()
        .map_err(|e: net::AddrParseError| -> Error { e.into() })
    {
        Ok(addr) => {
            let id = fc.shared_state_mut().net_loop.tcp_listen(addr);
            fc.shared_state_mut().set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.shared_state_mut().set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_accept_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let token = fc.mem().get_i32(sp + 8);
    let id = fc.shared_state_mut().net_loop.tcp_accept(token as usize);
    fc.shared_state_mut().set_usize_result(sp + 16, id);
}

extern "C" fn go_dial_tcp(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.mem().get_string(sp + 8).to_owned();
    match &addr
        .parse()
        .map_err(|e: net::AddrParseError| -> Error { e.into() })
    {
        Ok(addr) => {
            let id = fc.shared_state_mut().net_loop.tcp_connect(addr);
            fc.shared_state_mut().set_usize_result(sp + 24, id);
        }
        Err(err) => {
            fc.shared_state_mut().set_error(sp + 24, err);
        }
    }
}

extern "C" fn go_shutdown_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    let how = fc.mem().get_i32(sp + 8 + 4);
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
        fc.shared_state_mut().set_error(sp + 16, &err);
        fc.mem_mut().set_bool(sp + 16 + 4, false)
    } else {
        fc.mem_mut().set_bool(sp + 16 + 4, true)
    }
}

extern "C" fn go_write_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    let addr = fc.mem().get_i32(sp + 16);
    let ln = fc.mem().get_i32(sp + 24);
    let written = fc.shared_state().net_loop.write_stream(
        id as usize,
        fc.shared_state()
            .mem
            .mem_slice(addr as usize, (addr + ln) as usize),
    );
    fc.shared_state_mut().set_usize_result(sp + 40, written);
}

extern "C" fn go_net_get_error(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    match fc.shared_state_mut().net_loop.get_error(id as usize) {
        Ok(e) => {
            if let Some(e) = e {
                fc.shared_state_mut().set_error(sp + 16, &e.into());
                fc.mem_mut().set_bool(sp + 16 + 4, true);
            } else {
                fc.mem_mut().set_bool(sp + 16 + 4, false);
            }
        }
        Err(err) => {
            fc.shared_state_mut().set_error(sp + 16, &err);
            fc.mem_mut().set_bool(sp + 16 + 4, true);
        }
    }
}

extern "C" fn go_read_tcp_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    let start = fc.mem().get_i32(sp + 16);
    let end = fc.mem().get_i32(sp + 24) + start;

    let read = {
        let shared_state = fc.shared_state_mut();
        shared_state.net_loop.read_stream(
            id as usize,
            shared_state.mem.mut_mem_slice(start as usize, end as usize),
        )
    };
    fc.shared_state_mut().set_usize_result(sp + 40, read);
}

extern "C" fn go_close_listener_or_conn(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    // todo, pass error value

    if let Err(err) = fc.shared_state_mut().net_loop.close_conn(id as usize) {
        fc.shared_state_mut().set_error(sp + 16, &err);
        fc.mem_mut().set_bool(sp + 16 + 4, false);
    } else {
        fc.mem_mut().set_bool(sp + 16 + 4, true);
    }
}

extern "C" fn go_lookup_ip_addr(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let addr = fc.mem().get_string(sp + 8).to_owned();
    // TODO handle error
    match resolve_host(&addr) {
        Ok(ips) => {
            fc.mem_mut().set_bool(sp + 24 + 4, true);
            let mut byte_ips: Vec<Vec<u8>> = Vec::new();
            for ip in ips.iter() {
                match ip {
                    IpAddr::V4(ip4) => byte_ips.push(ip4.octets().to_vec()),
                    IpAddr::V6(_) => {} //no IPV6 support
                }
            }
            fc.shared_state_mut()
                .set_byte_array_array(sp + 24, byte_ips);
        }
        Err(err) => {
            fc.shared_state_mut().set_error(sp + 24, &err.into());
            fc.mem_mut().set_bool(sp + 24 + 4, false);
        }
    }
}

extern "C" fn go_local_addr(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    let start = fc.mem().get_i32(sp + 16);
    let end = fc.mem().get_i32(sp + 24) + start;
    // let (addr, len) = fc.mem();
    // let mem = unsafe { &mut slice::from_raw_parts_mut(addr, len)[start as usize..end as usize] };
    let addr = fc.shared_state().net_loop.local_addr(id as usize).unwrap();
    addr_to_bytes(
        addr,
        fc.mem_mut().mut_mem_slice(start as usize, end as usize),
    )
    .unwrap();
}

extern "C" fn go_remote_addr(vmctx: *mut VMContext, sp: i32) {
    let mut fc = FuncContext::new(vmctx);
    let id = fc.mem().get_i32(sp + 8);
    let start = fc.mem().get_i32(sp + 16);
    let end = fc.mem().get_i32(sp + 24) + start;
    let addr = fc.shared_state().net_loop.peer_addr(id as usize).unwrap();
    addr_to_bytes(
        addr,
        fc.mem_mut().mut_mem_slice(start as usize, end as usize),
    )
    .unwrap();
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
        None,
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
    let instantiate_timer = SystemTime::now();
    let instance = instantiate_go().expect("Instantiate go");
    context.name_instance("go".to_string(), instance);
    println!(
        "Instantiation time: {:?}",
        instantiate_timer.elapsed().unwrap()
    );

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
        let instance = context.get_instance(&"go").unwrap();
        let shared_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("not a thing");
        shared_state.add_definition(definition);
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
        let instance = context.get_instance(&"go").unwrap();
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

}
