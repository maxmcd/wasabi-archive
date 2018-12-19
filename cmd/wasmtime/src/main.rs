//! CLI tool to use the functions provided by the [wasmtime](../wasmtime/index.html)
//! crate.
//!
//! Reads Wasm binary files (one Wasm module per file), translates the functions' code to Cranelift
//! IL. Can also executes the `start` function of the module by laying out the memories, globals
//! and tables, then emitting the translated code with hardcoded addresses to memory.

#![deny(
    missing_docs,
    trivial_numeric_casts,
    unused_extern_crates,
    unstable_features
)]
#![warn(unused_import_braces)]
#![cfg_attr(feature = "clippy", plugin(clippy(conf_file = "../../clippy.toml")))]
#![cfg_attr(
    feature = "cargo-clippy",
    allow(clippy::new_without_default, clippy::new_without_default_derive)
)]
#![cfg_attr(
    feature = "cargo-clippy",
    warn(
        clippy::float_arithmetic,
        clippy::mut_mut,
        clippy::nonminimal_bool,
        clippy::option_map_unwrap_or,
        clippy::option_map_unwrap_or_else,
        clippy::unicode_not_nfc,
        clippy::use_self
    )
)]

extern crate cranelift_codegen;
#[macro_use]
extern crate cranelift_entity;
extern crate cranelift_native;
extern crate cranelift_wasm;
extern crate docopt;
extern crate target_lexicon;
extern crate wasmtime_environ;
extern crate wasmtime_execute;
extern crate wasmtime_runtime;
#[macro_use]
extern crate serde_derive;
extern crate file_per_thread_logger;
extern crate pretty_env_logger;
extern crate wabt;

use cranelift_codegen::isa::TargetIsa;
use cranelift_codegen::settings;
use cranelift_codegen::settings::Configurable;
use cranelift_codegen::{ir, isa};
use cranelift_entity::BoxedSlice;
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use docopt::Docopt;
use std::error::Error;
use std::fs::File;
use std::io;
use std::io::prelude::*;
use std::path::Path;
use std::path::PathBuf;
use std::process::exit;
use std::rc::Rc;
use target_lexicon::HOST;
use wasmtime_environ::{
    compile_module, translate_signature, Compilation, CompileError, Module, ModuleEnvironment,
    Tunables,
};
use wasmtime_execute::{link_module, ActionError, ActionOutcome, InstancePlus, JITCode, Resolver};
use wasmtime_runtime::{Export, Imports, InstantiationError, VMContext, VMFunctionBody};

static LOG_FILENAME_PREFIX: &str = "cranelift.dbg.";

const USAGE: &str = "
Wasm runner.
Takes a binary (wasm) or text (wat) WebAssembly module and instantiates it,
including calling the start function if one is present. Additional functions
given with --invoke are then called.
Usage:
    wasmtime [-od] <file>...
    wasmtime [-od] <file>... --invoke=<fn>
    wasmtime --help | --version
Options:
    --invoke=<fn>       name of function to run
    -o, --optimize      runs optimization passes on the translated functions
    -d, --debug         enable debug output on stderr/stdout
    -h, --help          print this help message
    --version           print the Cranelift version
";

#[derive(Deserialize, Debug, Clone)]
struct Args {
    arg_file: Vec<String>,
    flag_optimize: bool,
    flag_debug: bool,
    flag_invoke: Option<String>,
}

fn read_to_end(path: PathBuf) -> Result<Vec<u8>, io::Error> {
    let mut buf: Vec<u8> = Vec::new();
    let mut file = File::open(path)?;
    file.read_to_end(&mut buf)?;
    Ok(buf)
}

fn main() {
    let args: Args = Docopt::new(USAGE)
        .and_then(|d| {
            d.help(true)
                .version(Some(String::from("0.0.0")))
                .deserialize()
        })
        .unwrap_or_else(|e| e.exit());

    if args.flag_debug {
        pretty_env_logger::init();
    } else {
        file_per_thread_logger::initialize(LOG_FILENAME_PREFIX);
    }

    let isa_builder = cranelift_native::builder().unwrap_or_else(|_| {
        panic!("host machine is not a supported target");
    });
    let mut flag_builder = settings::builder();

    // Enable verifier passes in debug mode.
    if cfg!(debug_assertions) {
        flag_builder.enable("enable_verifier").unwrap();
    }

    // Enable optimization if requested.
    if args.flag_optimize {
        flag_builder.set("opt_level", "best").unwrap();
    }

    let isa = isa_builder.finish(settings::Flags::new(flag_builder));

    for filename in &args.arg_file {
        let path = Path::new(&filename);
        match handle_module(&args, path, &*isa) {
            Ok(()) => {}
            Err(message) => {
                let name = path.as_os_str().to_string_lossy();
                println!("error while processing {}: {}", name, message);
                exit(1);
            }
        }
    }
}

#[allow(clippy::print_stdout)]
unsafe extern "C" fn env_println(msg: *const u8, len: usize, vmctx: *mut VMContext) {
    println!("{:?}", len);
    println!("{:?}", msg.offset(1));
    println!("{:?}", msg.offset(0));
    let instance = (&mut *vmctx).instance();
    let _address = match instance.lookup_immutable("memory") {
        Some(Export::Memory {
            address,
            memory: _memory,
            vmctx: _vmctx,
        }) => address,
        Some(_) => {
            panic!("nomatch");
        }
        None => {
            panic!("nomatch 2");
        }
    };
}

struct WasmNamespace {
    instance: Option<InstancePlus>,
}

impl WasmNamespace {
    fn new() -> Self {
        Self { instance: None }
    }
}

impl Resolver for WasmNamespace {
    fn resolve(&mut self, module: &str, field: &str) -> Option<Export> {
        println!("Resolving {} {}", module, field);
        self.instance.as_ref().unwrap().instance.lookup(field)
    }
}

fn init_instance(
    jit_code: &mut JITCode,
    isa: &isa::TargetIsa,
    data: &[u8],
    resolver: &mut Resolver,
) -> Result<InstancePlus, ActionError> {
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = ir::types::Type::triple_pointer_type(&HOST);

    let mut module = Module::new();

    // TODO: Allow the tunables to be overridden.
    let tunables = Tunables::default();

    let (lazy_function_body_inputs, lazy_data_initializers) = {
        let environ = ModuleEnvironment::new(isa, &mut module, tunables);

        let translation = environ
            .translate(&data)
            .map_err(|error| ActionError::Compile(CompileError::Wasm(error)))
            .unwrap();

        (
            translation.lazy.function_body_inputs,
            translation.lazy.data_initializers,
        )
    };

    let (compilation, relocations) = compile_module(&module, &lazy_function_body_inputs, isa)
        .map_err(ActionError::Compile)
        .unwrap();

    let allocated_functions = allocate_functions(jit_code, compilation)
        .map_err(|message| {
            ActionError::Instantiate(InstantiationError::Resource(format!(
                "failed to allocate memory for functions: {}",
                message
            )))
        })
        .unwrap();

    let imports = link_module(&module, &allocated_functions, relocations, resolver)
        .map_err(ActionError::Link)
        .unwrap();

    // Gather up the pointers to the compiled functions.
    let mut finished_functions = allocated_functions
        .into_iter()
        .map(|(_index, allocated)| {
            let fatptr: *const [VMFunctionBody] = *allocated;
            fatptr as *const VMFunctionBody
        })
        .collect::<PrimaryMap<DefinedFuncIndex, *const VMFunctionBody>>();

    let sig = module.signatures.push(translate_signature(
        ir::Signature {
            params: vec![
                ir::AbiParam::new(ir::types::I32),
                ir::AbiParam::new(ir::types::I32),
            ],
            returns: vec![],
            call_conv,
        },
        pointer_type,
    ));
    let func = module.functions.push(sig);
    module.exports.insert(
        "println".to_owned(),
        wasmtime_environ::Export::Function(func),
    );
    finished_functions.push(env_println as *const VMFunctionBody);
    // Make all code compiled thus far executable.
    jit_code.publish();
    InstancePlus::with_parts(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
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

/// Return an instance implementing the "spectest" interface used in the
/// spec testsuite.
pub fn instantiate_spectest() -> Result<InstancePlus, ActionError> {
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = ir::types::Type::triple_pointer_type(&HOST);
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();

    let sig = module.signatures.push(translate_signature(
        ir::Signature {
            params: vec![
                ir::AbiParam::new(ir::types::I32),
                ir::AbiParam::new(ir::types::I32),
            ],
            returns: vec![],
            call_conv,
        },
        pointer_type,
    ));
    let func = module.functions.push(sig);
    module.exports.insert(
        "println".to_owned(),
        wasmtime_environ::Export::Function(func),
    );
    finished_functions.push(env_println as *const VMFunctionBody);

    let imports = Imports::none();
    let data_initializers = Vec::new();

    InstancePlus::with_parts(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
        imports,
        data_initializers,
    )
}

fn handle_module(args: &Args, path: &Path, isa: &TargetIsa) -> Result<(), String> {
    let mut data =
        read_to_end(path.to_path_buf()).map_err(|err| String::from(err.description()))?;
    // if data is using wat-format, first convert data to wasm
    if !data.starts_with(&[b'\0', b'a', b's', b'm']) {
        data = wabt::wat2wasm(data).map_err(|err| String::from(err.description()))?;
    }
    let mut resolver = WasmNamespace::new();
    let mut jit_code = JITCode::new();
    let mut instance_plus =
        init_instance(&mut jit_code, isa, &data, &mut resolver).map_err(|e| e.to_string())?;

    if let Some(ref f) = args.flag_invoke {
        match instance_plus
            .invoke(&mut jit_code, isa, &f, &[])
            .map_err(|e| e.to_string())?
        {
            ActionOutcome::Returned { .. } => {}
            ActionOutcome::Trapped { message } => {
                return Err(format!("Trap from within function {}: {}", f, message));
            }
        }
    }

    Ok(())
}
