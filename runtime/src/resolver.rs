use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use libc::socket;
use rand::{thread_rng, Rng};
use std::collections::HashMap;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::slice;
use std::str;
use std::sync::Mutex;
use std::time::{SystemTime, UNIX_EPOCH};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_execute::{ActionError, InstancePlus};
use wasmtime_runtime::{Imports, VMContext, VMFunctionBody, VMMemoryDefinition};

lazy_static! {
    static ref VALUES: Mutex<HashMap<u32, Vec<u8>>> = { Mutex::new(HashMap::new()) };
}

struct FuncContext {
    definition: *mut VMMemoryDefinition,
}

impl FuncContext {
    fn new(vmctx: *mut VMContext) -> Self {
        let instance = unsafe { (&mut *vmctx).instance() };
        let definition = match instance.lookup("memory") {
            Some(wasmtime_runtime::Export::Memory {
                definition,
                memory: _memory,
                vmctx: _vmctx,
            }) => (definition),
            Some(_) => {
                panic!("memory match didn't return a memory!");
            }
            None => {
                panic!("i've lost my mind");
            }
        };
        Self { definition }
    }

    unsafe fn get_u32(&self, sp: u32) -> u32 {
        let spu = sp as usize;
        let memory_def = &*self.definition;
        as_u32_le(&slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8])
    }
    unsafe fn get_string(&self, sp: u32) -> &str {
        let memory_def = &*self.definition;
        let saddr = self.get_u32(sp) as usize;
        let ln = self.get_u32(sp + 8) as usize;
        str::from_utf8(
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)[saddr..saddr + ln],
        )
        .unwrap()
    }
    unsafe fn set_u64(&self, sp: u32, num: u64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&u64_as_u8_le(num));
    }
    unsafe fn set_u32(&self, sp: u32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    unsafe fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
        let memory_def = &*self.definition;
        &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
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
        let mut values = VALUES.lock().unwrap();
        let reference = values.len() as u32;
        values.insert(reference, b);
        reference
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
    let definition = FuncContext::new(vmctx).definition;
    let memory_def = &*definition;
    let message =
        &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..start + len];
    println!("{:?}", str::from_utf8(&message).unwrap());
}

extern "C" fn go_debug(_sp: u32) {
    println!("debug")
}

unsafe extern "C" fn go_wasmexit(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let exit_code = fc.get_u32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    // TODO: exit program?
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

    let values = VALUES.lock().unwrap();
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&values[&reference]);
}
unsafe extern "C" fn go_prepare_bytes(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_u32(sp + 8);
    let values = VALUES.lock().unwrap();
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

unsafe extern "C" fn go_socket(sp: u32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let domain = fc.get_u32(sp + 8) as i32;
    let ty = fc.get_u32(sp + 16) as i32;
    let protocol = fc.get_u32(sp + 24) as i32;
    println!("{} {} {}", domain, ty, protocol);
    let fd = socket(domain, ty, protocol);
    println!("fd: {}", fd);
    fc.set_u32(sp + 32, fd as u32)
}

/// Return an instance implementing the "spectest" interface used in the
/// spec testsuite.
pub fn instantiate_env() -> Result<InstancePlus, ActionError> {
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

    InstancePlus::with_parts(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
        imports,
        data_initializers,
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

pub fn instantiate_go() -> Result<InstancePlus, ActionError> {
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
        "syscall.socket".to_owned(),
    );
    finished_functions.push(go_socket as *const VMFunctionBody);

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

    InstancePlus::with_parts(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
        imports,
        data_initializers,
    )
}
