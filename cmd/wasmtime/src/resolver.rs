use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use std::rc::Rc;
use std::slice;
use std::str;
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_execute::{ActionError, InstancePlus};
use wasmtime_runtime::{Imports, VMContext, VMFunctionBody};

#[allow(clippy::print_stdout)]
unsafe extern "C" fn env_println(start: usize, len: usize, vmctx: *mut VMContext) {
    let instance = (&mut *vmctx).instance();
    let address = match instance.lookup_immutable("memory") {
        Some(wasmtime_runtime::Export::Memory {
            address,
            memory: _memory,
            vmctx: _vmctx,
        }) => (address),
        Some(_) => {
            panic!("nomatch");
        }
        None => {
            panic!("nomatch 2");
        }
    };

    let memory_def = &*address;
    let foo =
        &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..start + len];
    println!("{:?}", str::from_utf8(&foo).unwrap());

    // let fd: i32 = varargs.get(instance);
    // assert!(!msg.is_null());
    // println!("{}", msg);
}

/// Return an instance implementing the "spectest" interface used in the
/// spec testsuite.
pub fn instantiate_spectest() -> Result<InstancePlus, ActionError> {
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
            minimum: 17,
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
