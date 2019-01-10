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
enum JsValue {
    Bytes(Vec<u8>),
    String(String),
    Int(u32),
    Values(Vec<JsValue>),
}

pub struct SharedState {
    pub definition: Option<*mut VMMemoryDefinition>,
    pub result_sender: Option<mpsc::Sender<String>>,
    values: HashMap<u32, JsValue>,
    envvars: HashMap<String, String>,
    callback_count: i32,
}
impl SharedState {
    fn new() -> Self {
        Self {
            values: HashMap::new(),
            envvars: HashMap::new(),
            result_sender: None,
            definition: None,
            callback_count: 0,
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
    fn result_sender(&self) -> &mpsc::Sender<String> {
        self.shared_state()
            .result_sender
            .as_ref()
            .expect("I should have a sender")
    }
    fn values(&self) -> &mut HashMap<u32, JsValue> {
        &mut self.shared_state().values
    }
    fn envvars(&self) -> &mut HashMap<String, String> {
        &mut self.shared_state().envvars
    }
    fn get_u32(&self, sp: u32) -> u32 {
        let spu = sp as usize;
        unsafe {
            let memory_def = &*self.definition();
            as_u32_le(
                &slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8],
            )
        }
    }
    fn get_u64(&self, sp: u32) -> u64 {
        let spu = sp as usize;
        unsafe {
            let memory_def = &*self.definition();
            as_u64_le(
                &slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8],
            )
        }
    }
    fn get_f64(&self, sp: u32) -> f64 {
        f64::from_bits(self.get_u64(sp))
    }
    fn get_bytes(&self, sp: u32) -> &[u8] {
        let saddr = self.get_u32(sp) as usize;
        let ln = self.get_u32(sp + 8) as usize;
        self._get_bytes(saddr, ln)
    }
    fn _get_bytes(&self, address: usize, ln: usize) -> &[u8] {
        let memory_def = unsafe { &*self.definition() };
        unsafe {
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)
                [address..address + ln]
        }
    }
    fn get_string(&self, sp: u32) -> &str {
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
            let reference = self.store_value_bytes(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&u32_as_u8_le(reference));
        }
        self.set_u32(addr, self.store_value_bytes(byte_references))
    }
    fn store_value_bytes(&self, b: Vec<u8>) -> u32 {
        let reference = self.values().len() as u32;
        self.values().insert(reference, JsValue::Bytes(b));
        reference
    }
    fn store_value(self, b: JsValue) -> u32 {
        let reference = self.values().len() as u32;
        self.values().insert(reference, b);
        reference
    }
    fn store_string(&self, address: u32, val: String) {
        self.set_u32(address, self.store_value_bytes(val.into_bytes()));
    }
    fn load_string(&self, address: u32) -> String {
        let reference = self.get_u32(address);
        let b = match self.values().get(&reference).unwrap() {
            JsValue::Bytes(b) => b,
            _ => panic!("load_string needs bytes"),
        };
        str::from_utf8(b).unwrap().to_string()
    }
    fn load_slice_values(&self, address: u32) -> Vec<JsValue> {
        let mut out = Vec::new();
        let array = self.get_u32(address);
        let len = self.get_u32(address + 8);
        for n in 0..len {
            out.push(self.load_value(array + n * 8));
        }
        out
    }
    fn load_value(&self, address: u32) -> JsValue {
        let float = self.get_f64(address);
        let intfloat = float as u32;

        if float == (intfloat) as f64 {
            //https://stackoverflow.com/questions/48500261/check-if-a-float-can-be-converted-to-integer-without-loss
            return JsValue::Int(intfloat);
        }
        let reference = self.get_u32(address);
        self.values().remove(&reference).unwrap()
    }
}

fn as_u32_le(array: &[u8]) -> u32 {
    ((array[0] as u32) << 0)
        | ((array[1] as u32) << 8)
        | ((array[2] as u32) << 16)
        | ((array[3] as u32) << 24)
}

fn as_u64_le(array: &[u8]) -> u64 {
    ((array[0] as u64) << 0)
        | ((array[1] as u64) << 8)
        | ((array[2] as u64) << 16)
        | ((array[3] as u64) << 24)
        | ((array[4] as u64) << 32)
        | ((array[5] as u64) << 40)
        | ((array[6] as u64) << 48)
        | ((array[7] as u64) << 56)
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

extern "C" fn go_schedule_callback(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let count = fc.get_u64(sp + 8);
    println!("schedule callback at time {:?}", count);
}
extern "C" fn go_clear_scheduled_callback(_sp: u32) {
    println!("go_clear_scheduled_callback")
}
extern "C" fn go_syscall(_sp: u32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(_sp: u32) {
    println!("go_js_string_val")
}

extern "C" fn go_js_value_get(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_u32(sp + 8);
    let name = fc.get_string(sp + 16);
    // implement nanHead
    fc.store_string(sp + 32, name.to_string());
    println!("js_value_get {} {}", name, reference);
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
extern "C" fn go_js_value_call(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // const loadSliceOfValues = (addr) => {
    //     const array = getInt64(addr + 0);
    //     const len = getInt64(addr + 8);
    //     const a = new Array(len);
    //     for (let i = 0; i < len; i++) {
    //         a[i] = loadValue(array + i * 8);
    //     }
    //     return a;
    // }
    let array = fc.get_u32(sp + 32);
    let len = fc.get_u32(sp + 32 + 8);
    let object = fc.load_string(sp + 8);
    let method = fc.get_string(sp + 16);
    println!("js_value_call {} {} {} {}", object, method, array, len);

    if object == "fs" && method == "writeSync" {
        // println!("fd {:?}", fc.get_f64(array + 0 * 8));
        let out = match fc.values().get(&fc.get_u32(array + 1 * 8)).unwrap() {
            JsValue::Bytes(b) => b,
            _ => panic!("writeSync should write bytes"),
        };
        print!("{}", str::from_utf8(out).unwrap());
        // println!("offset {:?}", fc.get_f64(array + 2 * 8));
        // // still need to respec this len even if we're ignoring it
        // println!("len {:?}", fc.get_f64(array + 3 * 8));
    }
}
extern "C" fn go_js_value_new(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let array = fc.get_u32(sp + 16);
    let len = fc.get_u32(sp + 16 + 8);
    let name = fc.load_string(sp + 8);
    println!("js_value_new {} {} {}", name, array, len);
    if name == "Uint8Array" {
        let reference = fc.store_value_bytes(
            fc._get_bytes(
                fc.get_f64(array + 1 * 8) as usize, // pointer
                fc.get_f64(array + 2 * 8) as usize, // len
            )
            .to_vec(),
        );
        fc.set_u32(sp + 40, reference)
    } else {
        fc.store_string(sp + 40, "value_new_value".to_string());
    }

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
    let key = fc.get_string(sp + 8);
    let value = fc.get_string(sp + 24);
    let envvars = fc.envvars();
    envvars.insert(key.to_owned(), value.to_owned());
}

extern "C" fn go_get_env(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let key = fc.get_string(sp + 8);
    let envvars = fc.envvars();
    match envvars.get(key) {
        Some(value) => unsafe {
            fc.set_bool(sp + 24, true);
            fc.store_string(sp + 28, value.to_string());
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
    let sender = fc.result_sender();
    sender.send(fc.get_string(sp + 24 + 8).to_string()).unwrap();
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
    let b = match values[&reference] {
        JsValue::Bytes(ref b) => b,
        _ => panic!("load_bytes needs bytes"),
    };
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b);
}
unsafe extern "C" fn go_prepare_bytes(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_u32(sp + 8);
    let values = fc.values();
    let b = match values[&reference] {
        JsValue::Bytes(ref b) => b,
        _ => panic!("prepare_bytes needs bytes"),
    };
    fc.set_u64(sp + 16, b.len() as u64);
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

pub fn start_event_loop() -> mpsc::Sender<String> {
    let (send, recv) = mpsc::channel();

    thread::spawn(move || loop {
        match recv.try_recv() {
            Ok(pay) => {
                println!("got payload{:?}", pay);
                // Client::new().get(&pay).send();
            }
            Err(err) => match err {
                std::sync::mpsc::TryRecvError::Empty => {}
                std::sync::mpsc::TryRecvError::Disconnected => {
                    return;
                }
            },
        };
    });

    send
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

pub fn instantiate_go() -> Result<Instance, InstantiationError> {
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);

    let functions = [
        ("debug", go_debug as *const VMFunctionBody),
        ("runtime.wasmExit", go_wasmexit as *const VMFunctionBody),
        ("runtime.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("syscall.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("runtime.nanotime", go_nanotime as *const VMFunctionBody),
        ("runtime.walltime", go_walltime as *const VMFunctionBody),
        ("syscall.Syscall", go_syscall as *const VMFunctionBody),
        ("net.lookupHost", go_lookup_ip as *const VMFunctionBody),
        ("syscall.socket", go_debug as *const VMFunctionBody),
        (
            "runtime.scheduleCallback",
            go_schedule_callback as *const VMFunctionBody,
        ),
        (
            "runtime.clearScheduledCallback",
            go_clear_scheduled_callback as *const VMFunctionBody,
        ),
        (
            "runtime.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.setenv",
            go_set_env as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.getenv",
            go_get_env as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.loadBytes",
            go_load_bytes as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.prepareBytes",
            go_prepare_bytes as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm/http.startRequest",
            go_start_request as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.loadBytes",
            go_load_bytes as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.prepareBytes",
            go_prepare_bytes as *const VMFunctionBody,
        ),
        (
            "syscall/js.stringVal",
            go_js_string_val as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueGet",
            go_js_value_get as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueSet",
            go_js_value_set as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueIndex",
            go_js_value_index as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueSetIndex",
            go_js_value_set_index as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueCall",
            go_js_value_call as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueNew",
            go_js_value_new as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueInvoke",
            go_js_value_invoke as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueLength",
            go_js_value_length as *const VMFunctionBody,
        ),
        (
            "syscall/js.valuePrepareString",
            go_js_value_prepare_string as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueLoadString",
            go_js_value_load_string as *const VMFunctionBody,
        ),
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
