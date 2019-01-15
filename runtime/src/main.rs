//! Wasmtime is a user of wasmtime without enough creatifivy to come up with a new name

#![deny(missing_docs, trivial_numeric_casts, unstable_features)]
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
// #![feature(futures_api)]

extern crate cranelift_codegen;
#[macro_use]
extern crate cranelift_entity;
extern crate cranelift_native;
extern crate cranelift_wasm;
extern crate docopt;
extern crate rand;
extern crate reqwest;
extern crate target_lexicon;
extern crate wasmtime_environ;
extern crate wasmtime_jit;
extern crate wasmtime_runtime;
#[macro_use]
extern crate serde_derive;
extern crate file_per_thread_logger;
extern crate pretty_env_logger;
extern crate wabt;

mod resolver;

use cranelift_codegen::settings;
use cranelift_codegen::settings::Configurable;
use docopt::Docopt;

use std::error::Error;
use std::fs::File;
use std::io;
use std::io::prelude::*;
use std::path::Path;
use std::path::PathBuf;
use std::process::exit;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{thread, time};
use wasmtime_jit::{instantiate, ActionOutcome, Compiler, Namespace};

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

/// An opaque reference to an `InstancePlus`.
#[derive(Copy, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct InstancePlusIndex(u32);
entity_impl!(InstancePlusIndex, "instance");

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
    let mut compiler = Compiler::new(isa);

    for filename in &args.arg_file {
        let path = Path::new(&filename);
        match handle_module(&mut compiler, &args, path) {
            Ok(()) => {}
            Err(message) => {
                let name = path.as_os_str().to_string_lossy();
                println!("error while processing {}: {}", name, message);
                exit(1);
            }
        }
    }
}

fn handle_module(compiler: &mut Compiler, args: &Args, path: &Path) -> Result<(), String> {
    let mut data =
        read_to_end(path.to_path_buf()).map_err(|err| String::from(err.description()))?;
    // if data is using wat-format, first convert data to wasm
    if !data.starts_with(&[b'\0', b'a', b's', b'm']) {
        data = wabt::wat2wasm(data).map_err(|err| String::from(err.description()))?;
    }

    let mut c = Box::new(compiler);

    let mut namespace = Namespace::new();

    let instance = resolver::instantiate_env().expect("Instantiate env");
    let env_index = namespace.instance(Some("env"), instance);

    let instance = resolver::instantiate_go().expect("Instantiate go");
    let go_index = namespace.instance(Some("go"), instance);
    // let index = resolver.instances.push(instance);
    // resolver.names.insert("env".to_owned(), index);

    // let index = resolver.instances.push(instance);
    // resolver.names.insert("go".to_owned(), index);
    let instantiate_timer = SystemTime::now();
    let mut instance = instantiate(&mut *c, &data, &mut namespace).map_err(|e| e.to_string())?;
    println!(
        "Instantiation time: {:?}",
        instantiate_timer.elapsed().unwrap()
    );
    // {
    //     let state = instance.host_state();
    //     let val = state.downcast_mut::<Box<SharedState>>().unwrap();
    //     *val = Box::new(SharedState::new());
    //     // *state = *(Box::new(SharedState::new()) as Box<dyn Any + 'static>);
    //     // let ss: Box<dyn Any + 'static> = Box::new(SharedState::new());
    //     // *state = *ss;
    // }
    let definition = match instance.lookup("mem") {
        Some(wasmtime_runtime::Export::Memory {
            definition,
            memory: _memory,
            vmctx: _vmctx,
        }) => definition,
        Some(_) => panic!("exported item is not a linear memory",),
        None => match instance.lookup("memory") {
            Some(wasmtime_runtime::Export::Memory {
                definition,
                memory: _memory,
                vmctx: _vmctx,
            }) => definition,
            Some(_) => panic!("exported item is not a linear memory",),
            None => panic!("no memory export found"),
        },
    };
    // host_state.definition = Some(definition);

    let index = namespace.instance(Some("main"), instance);
    {
        let instance = &mut namespace.instances[go_index];
        let host_state = instance
            .host_state()
            .downcast_mut::<resolver::SharedState>()
            .expect("not a thing");
        host_state.definition = Some(definition);
        host_state.result_sender = Some(resolver::start_event_loop());
    }
    {
        let instance = &mut namespace.instances[env_index];
        let host_state = instance
            .host_state()
            .downcast_mut::<resolver::SharedState>()
            .expect("not a thing");
        host_state.definition = Some(definition);
    }
    // println!("{:?}", namespace.instances);
    // let mut jit_code = JITCode::new();
    // let mut instance_plus = instance_plus_plus::new(&mut jit_code, isa, &data, &mut resolver)
    //     .map_err(|e| e.to_string())?;

    // resolver::start_event_loop();
    let mut function_name = "run";
    let mut one_chance = true;
    if let Some(ref f) = args.flag_invoke {
        let invoke_timer = SystemTime::now();
        loop {
            println!("Running {:?}", function_name);
            match namespace
                .invoke(&mut *c, index, function_name, &[])
                .map_err(|e| e.to_string())?
            {
                ActionOutcome::Returned { .. } => {}
                ActionOutcome::Trapped { message } => {
                    return Err(format!("Trap from within function {}: {}", f, message));
                }
            }
            function_name = "resume";
            let instance = &mut namespace.instances[go_index];
            let host_state = instance
                .host_state()
                .downcast_mut::<resolver::SharedState>()
                .expect("not a thing");
            if host_state.should_resume == true {
                host_state.should_resume = false;
                continue;
            }
            if let Some(callback) = host_state.callback_heap.pop() {
                let sleep_time = time::Duration::from_millis((callback.time - ms_epoch()) as u64);
                thread::sleep(sleep_time);
                continue;
            }
            if one_chance == true {
                one_chance = false;
                continue;
            }
            break;
        }
        println!("Invocation time: {:?}", invoke_timer.elapsed().unwrap());
    }

    Ok(())
}

fn ms_epoch() -> i64 {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    since_the_epoch.as_secs() as i64 * 1000 + since_the_epoch.subsec_nanos() as i64 / 1_000_000
}
