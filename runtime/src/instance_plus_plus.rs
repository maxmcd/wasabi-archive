use cranelift_codegen::isa;
use cranelift_entity::{BoxedSlice, PrimaryMap};
use cranelift_wasm::DefinedFuncIndex;
use std::rc::Rc;
use std::time::SystemTime;
use wasmtime_environ::{
    compile_module, Compilation, CompileError, Module, ModuleEnvironment, Tunables,
};
use wasmtime_execute::{link_module, ActionError, InstancePlus, JITCode, Resolver};
use wasmtime_runtime::{InstantiationError, VMFunctionBody};

pub fn new(
    jit_code: &mut JITCode,
    isa: &isa::TargetIsa,
    data: &[u8],
    resolver: &mut Resolver,
) -> Result<InstancePlus, ActionError> {
    let mut module = Module::new();

    // TODO: Allow the tunables to be overridden.
    let tunables = Tunables::default();

    let (lazy_function_body_inputs, lazy_data_initializers) = {
        let environ = ModuleEnvironment::new(isa, &mut module, tunables);

        let translation = environ
            .translate(&data)
            .map_err(|error| ActionError::Compile(CompileError::Wasm(error)))?;

        (
            translation.lazy.function_body_inputs,
            translation.lazy.data_initializers,
        )
    };

    // module
    //     .imported_memories
    //     .push(("env".to_owned(), "memory".to_owned()));
    module
        .imported_memories
        .push(("go".to_owned(), "memory".to_owned()));

    let compilation_timer = SystemTime::now();
    let (compilation, relocations) =
        compile_module(&module, &lazy_function_body_inputs, isa).map_err(ActionError::Compile)?;

    println!(
        "Compilation time: {:?}",
        compilation_timer.elapsed().unwrap()
    );

    let import_finish_publish_timer = SystemTime::now();

    let allocated_functions = allocate_functions(jit_code, compilation).map_err(|message| {
        ActionError::Instantiate(InstantiationError::Resource(format!(
            "failed to allocate memory for functions: {}",
            message
        )))
    })?;

    println!(
        "Allocated functions after: {:?}",
        import_finish_publish_timer.elapsed().unwrap()
    );

    let imports = link_module(&module, &allocated_functions, relocations, resolver)
        .map_err(ActionError::Link)?;

    println!(
        "link_module after: {:?}",
        import_finish_publish_timer.elapsed().unwrap()
    );
    // Gather up the pointers to the compiled functions.
    let finished_functions: BoxedSlice<DefinedFuncIndex, *const VMFunctionBody> =
        allocated_functions
            .into_iter()
            .map(|(_index, allocated)| {
                let fatptr: *const [VMFunctionBody] = *allocated;
                fatptr as *const VMFunctionBody
            })
            .collect::<PrimaryMap<_, _>>()
            .into_boxed_slice();

    // Make all code compiled thus far executable.
    jit_code.publish();
    println!(
        "Published after: {:?}",
        import_finish_publish_timer.elapsed().unwrap()
    );

    InstancePlus::with_parts(
        Rc::new(module),
        finished_functions,
        imports,
        lazy_data_initializers,
    )
}

fn allocate_functions(
    jit_code: &mut JITCode,
    compilation: Compilation,
) -> Result<PrimaryMap<DefinedFuncIndex, *mut [VMFunctionBody]>, String> {
    let mut result = PrimaryMap::with_capacity(compilation.functions.len());
    for (_, body) in compilation.functions.into_iter() {
        let fatptr: *mut [VMFunctionBody] = jit_code.allocate_copy_of_byte_slice(body)?;
        result.push(fatptr);
    }
    Ok(result)
}
