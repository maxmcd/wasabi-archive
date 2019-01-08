use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use rand::{thread_rng, Rng};
use reqwest::async::Client;
use std::collections::HashMap;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::slice;
use std::sync::mpsc;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{str, thread};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::InstantiationError;
use wasmtime_runtime::{Imports, Instance, VMContext, VMFunctionBody, VMMemoryDefinition};

struct FuncContext {
    vmctx: *mut VMContext,
}

pub struct SharedState {
    pub definition: Option<*mut VMMemoryDefinition>,
    values: HashMap<u32, Vec<u8>>,
    pub envvars: HashMap<String, String>,
}
impl SharedState {
    fn new() -> Self {
        Self {
            values: HashMap::new(),
            envvars: HashMap::new(),
            definition: None,
        }
    }
}

impl FuncContext {
    fn new(vmctx: *mut VMContext) -> Self {
        Self { vmctx: vmctx }
    }

    fn shared_state(&self) -> &mut SharedState {
        unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }

    unsafe fn definition(&self) -> *mut VMMemoryDefinition {
        self.shared_state().definition.unwrap()
    }

    fn values(&self) -> &mut HashMap<u32, Vec<u8>> {
        &mut self.shared_state().values
    }
    fn envvars(&self) -> &mut HashMap<String, String> {
        &mut self.shared_state().envvars
    }
    unsafe fn get_u32(&self, sp: u32) -> u32 {
        let spu = sp as usize;
        let memory_def = &*self.definition();
        as_u32_le(&slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8])
    }
    unsafe fn get_bytes(&self, sp: u32) -> &[u8] {
        let memory_def = &*self.definition();
        let saddr = self.get_u32(sp) as usize;
        let ln = self.get_u32(sp + 8) as usize;
        &slice::from_raw_parts(memory_def.base, memory_def.current_length)[saddr..saddr + ln]
    }
    unsafe fn get_string(&self, sp: u32) -> &str {
        str::from_utf8(self.get_bytes(sp)).unwrap()
    }
    fn set_u64(&self, sp: u32, num: u64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&u64_as_u8_le(num));
    }
    fn set_u32(&self, sp: u32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
    }
    unsafe fn set_bool(&self, addr: u32, value: bool) {
        let val = if value { 1 } else { 0 };
        self.mut_mem_slice(addr as usize, (addr + 1) as usize)
            .clone_from_slice(&[val]);
    }
    unsafe fn set_byte_array_array(&self, addr: u32, values: Vec<Vec<u8>>) {
        let mut byte_references = vec![0; values.len() * 4];
        for (i, value) in values.iter().enumerate() {
            let reference = self.store_value(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&u32_as_u8_le(reference));
        }
        self.set_u32(addr, self.store_value(byte_references))
    }
    fn store_value(&self, b: Vec<u8>) -> u32 {
        let reference = self.values().len() as u32;
        self.values().insert(reference, b);
        reference
    }
    unsafe fn set_string(&self, address: u32, val: String) {
        self.set_u32(address, self.store_value(val.into_bytes()));
    }
}

fn as_u32_le(array: &[u8]) -> u32 {
    ((array[0] as u32) << 0)
        | ((array[1] as u32) << 8)
        | ((array[2] as u32) << 16)
        | ((array[3] as u32) << 24)
}

fn u64_as_u8_le(x: u64) -> [u8; 8] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
        ((x >> 32) & 0xff) as u8,
        ((x >> 40) & 0xff) as u8,
        ((x >> 48) & 0xff) as u8,
        ((x >> 56) & 0xff) as u8,
    ]
}

fn u32_as_u8_le(x: u32) -> [u8; 4] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
    ]
}

#[allow(clippy::print_stdout)]
unsafe extern "C" fn env_println(start: usize, len: usize, vmctx: *mut VMContext) {
    let definition = FuncContext::new(vmctx).definition();
    let memory_def = &*definition;
    let message =
        &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..start + len];
    println!("{:?}", str::from_utf8(&message).unwrap());
}

extern "C" fn go_debug(_sp: u32) {
    println!("debug")
}

extern "C" fn go_js_string_val(_sp: u32) {
    println!("go_js_string_val")
}

extern "C" fn go_js_value_get(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    println!("js_value_get {}", unsafe { fc.get_string(sp + 16) });
}
extern "C" fn go_js_value_set(_sp: u32) {
    println!("js_value_set")
}
extern "C" fn go_js_value_index(_sp: u32) {
    println!("js_value_index")
}
extern "C" fn go_js_value_set_index(_sp: u32) {
    println!("js_value_set_index")
}
extern "C" fn go_js_value_invoke(_sp: u32) {
    println!("js_value_invoke")
}
extern "C" fn go_js_value_call(_sp: u32) {
    println!("js_value_call")
}
extern "C" fn go_js_value_new(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // just always lie and say it worked
    unsafe { fc.set_bool(sp + 48, true) };
}
extern "C" fn go_js_value_length(_sp: u32) {
    println!("js_value_length")
}
extern "C" fn go_js_value_prepare_string(_sp: u32) {
    println!("js_value_prepare_string")
}
extern "C" fn go_js_value_load_string(_sp: u32) {
    println!("js_value_load_string")
}

extern "C" fn go_set_env(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let key = unsafe { fc.get_string(sp + 8) };
    let value = unsafe { fc.get_string(sp + 24) };
    let envvars = fc.envvars();
    envvars.insert(key.to_owned(), value.to_owned());
}

extern "C" fn go_get_env(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let key = unsafe { fc.get_string(sp + 8) };
    let envvars = fc.envvars();
    match envvars.get(key) {
        Some(value) => unsafe {
            fc.set_bool(sp + 24, true);
            fc.set_string(sp + 28, value.to_string());
        },
        None => unsafe {
            fc.set_bool(sp + 24, false);
        },
    }
}

unsafe extern "C" fn go_wasmexit(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let exit_code = fc.get_u32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    // TODO: exit program?
}
unsafe extern "C" fn go_start_request(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    println!("{:?}", fc.get_string(sp + 8));
    let memory_def = &*fc.definition();
    println!(
        "{:?}",
        &slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)
            [(sp as usize)..(sp + 100) as usize]
    );
    let sender = RESULT_SENDER.lock().unwrap();
    let send = sender.as_ref().unwrap();
    send.send(fc.get_string(sp + 24 + 8).to_string()).unwrap();
}

unsafe extern "C" fn go_wasmwrite(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    print!("{}", fc.get_string(sp + 16));
}

unsafe extern "C" fn go_walltime(sp: u32, vmctx: *mut VMContext) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let fc = FuncContext::new(vmctx);
    fc.set_u64(sp + 8, since_the_epoch.as_secs());
    fc.set_u32(sp + 8 + 8, since_the_epoch.subsec_nanos());
}

unsafe extern "C" fn go_nanotime(sp: u32, vmctx: *mut VMContext) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let ms_epoch =
        since_the_epoch.as_secs() * 1000 + since_the_epoch.subsec_nanos() as u64 / 1_000_000;
    let fc = FuncContext::new(vmctx);
    fc.set_u64(sp + 8, ms_epoch);
}

unsafe extern "C" fn go_get_random_data(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // let random_bytes = rand::thread_rng().gen::<[u8; 32]>();
    let addr = fc.get_u32(sp + 8);
    let ln = fc.get_u32(sp + 16);
    thread_rng().fill(fc.mut_mem_slice(addr as usize, (addr + ln) as usize));
}

unsafe extern "C" fn go_load_bytes(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_u32(sp + 8);
    let addr = fc.get_u32(sp + 16);
    let ln = fc.get_u32(sp + 24);

    let values = fc.values();
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&values[&reference]);
}
unsafe extern "C" fn go_prepare_bytes(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_u32(sp + 8);
    let values = fc.values();
    fc.set_u64(sp + 16, values[&reference].len() as u64)
}

unsafe extern "C" fn go_lookup_ip(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    // TODO handle error
    let ips = resolve_host(&addr).unwrap();
    fc.set_bool(sp + 24 + 4, true);
    let mut byte_ips: Vec<Vec<u8>> = Vec::new();
    println!("{:?}", ips);
    for ip in ips.iter() {
        match ip {
            IpAddr::V4(ip4) => byte_ips.push(ip4.octets().to_vec()),
            IpAddr::V6(_) => {}
        }
    }
    fc.set_byte_array_array(sp + 24, byte_ips)
}

fn resolve_host(host: &str) -> Result<Vec<IpAddr>, std::io::Error> {
    (host, 0)
        .to_socket_addrs()
        .map(|iter| iter.map(|socket_address| socket_address.ip()).collect())
}

pub fn start_event_loop() {
    let (send, recv) = mpsc::channel();
    let mut rs = RESULT_SENDER.lock().unwrap();
    *rs = Some(send);

    thread::spawn(move || loop {
        match recv.try_recv() {
            Ok(pay) => {
                println!("got payload{:?}", pay);
                // Client::new().get(&pay).send();
            }
            Err(err) => match err {
                std::sync::mpsc::TryRecvError::Empty => {}
                std::sync::mpsc::TryRecvError::Disconnected => {
                    panic!("message receiver has disconnected")
                }
            },
        };
    });
}

/// Return an instance implementing the "spectest" interface used in the
/// spec testsuite.
pub fn instantiate_env() -> Result<Instance, InstantiationError> {
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();

    let sig = module.signatures.push(translate_signature(
        ir::Signature {
            params: vec![ir::AbiParam::new(types::I32), ir::AbiParam::new(types::I32)],
            returns: vec![],
            call_conv,
        },
        pointer_type,
    ));
    let func = module.functions.push(sig);
    module
        .exports
        .insert("println".to_owned(), Export::Function(func));
    finished_functions.push(env_println as *const VMFunctionBody);

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
        .insert("memory".to_owned(), Export::Memory(memory));

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

fn register_func(module: &mut Module, params: Vec<ir::AbiParam>, name: String) {
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);

    let sig = module.signatures.push(translate_signature(
        ir::Signature {
            params,
            returns: vec![],
            call_conv,
        },
        pointer_type,
    ));
    let func = module.functions.push(sig);
    module
        .exports
        .insert(name.to_owned(), Export::Function(func));
}

pub fn instantiate_go() -> Result<Instance, InstantiationError> {
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32), ir::AbiParam::new(types::I32)],
        "println".to_owned(),
    );
    finished_functions.push(env_println as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "debug".to_owned(),
    );
    finished_functions.push(go_debug as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.wasmExit".to_owned(),
    );
    finished_functions.push(go_wasmexit as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.wasmWrite".to_owned(),
    );
    finished_functions.push(go_wasmwrite as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall.wasmWrite".to_owned(),
    );
    finished_functions.push(go_wasmwrite as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.nanotime".to_owned(),
    );
    finished_functions.push(go_nanotime as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.walltime".to_owned(),
    );
    finished_functions.push(go_walltime as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.scheduleCallback".to_owned(),
    );
    finished_functions.push(go_debug as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.clearScheduledCallback".to_owned(),
    );
    finished_functions.push(go_debug as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "runtime.getRandomData".to_owned(),
    );
    finished_functions.push(go_get_random_data as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/wasm.getRandomData".to_owned(),
    );
    finished_functions.push(go_get_random_data as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm.getRandomData".to_owned(),
    );
    finished_functions.push(go_get_random_data as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm.setenv".to_owned(),
    );
    finished_functions.push(go_set_env as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm.getenv".to_owned(),
    );
    finished_functions.push(go_get_env as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm.loadBytes".to_owned(),
    );
    finished_functions.push(go_load_bytes as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm.prepareBytes".to_owned(),
    );
    finished_functions.push(go_prepare_bytes as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "github.com/maxmcd/wasm-servers/gowasm/http.startRequest".to_owned(),
    );
    finished_functions.push(go_start_request as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/wasm.loadBytes".to_owned(),
    );
    finished_functions.push(go_load_bytes as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/wasm.prepareBytes".to_owned(),
    );
    finished_functions.push(go_prepare_bytes as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall.Syscall".to_owned(),
    );
    finished_functions.push(go_debug as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "net.lookupHost".to_owned(),
    );
    finished_functions.push(go_lookup_ip as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.stringVal".to_owned(),
    );
    finished_functions.push(go_js_string_val as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueGet".to_owned(),
    );
    finished_functions.push(go_js_value_get as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueSet".to_owned(),
    );
    finished_functions.push(go_js_value_set as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueIndex".to_owned(),
    );
    finished_functions.push(go_js_value_index as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueSetIndex".to_owned(),
    );
    finished_functions.push(go_js_value_set_index as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueCall".to_owned(),
    );
    finished_functions.push(go_js_value_call as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueNew".to_owned(),
    );
    finished_functions.push(go_js_value_new as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueInvoke".to_owned(),
    );
    finished_functions.push(go_js_value_invoke as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueLength".to_owned(),
    );
    finished_functions.push(go_js_value_length as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valuePrepareString".to_owned(),
    );
    finished_functions.push(go_js_value_prepare_string as *const VMFunctionBody);
    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall/js.valueLoadString".to_owned(),
    );
    finished_functions.push(go_js_value_load_string as *const VMFunctionBody);

    register_func(
        &mut module,
        vec![ir::AbiParam::new(types::I32)],
        "syscall.socket".to_owned(),
    );
    finished_functions.push(go_debug as *const VMFunctionBody);

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
