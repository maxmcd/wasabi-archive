//! Runtime is a wasm go runtime

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

extern crate cranelift_codegen;
extern crate cranelift_entity;
extern crate cranelift_native;
extern crate cranelift_wasm;
extern crate docopt;
extern crate file_per_thread_logger;
extern crate mio;
extern crate pretty_env_logger;
extern crate rand;
extern crate reqwest;
extern crate serde_derive;
extern crate target_lexicon;
extern crate wabt;
extern crate wasmtime_environ;
extern crate wasmtime_jit;
extern crate wasmtime_runtime;

mod go;
mod js;
mod pool;

use cranelift_codegen::settings;
use cranelift_codegen::settings::Configurable;
use std::env::args;
use std::error::Error;
use std::fs::File;
use std::io;
use std::io::prelude::*;
use std::path::Path;
use std::path::PathBuf;
use std::process::exit;
use wasmtime_jit::Compiler;

static LOG_FILENAME_PREFIX: &str = "cranelift.dbg.";

fn read_to_end(path: PathBuf) -> Result<Vec<u8>, io::Error> {
    let mut buf: Vec<u8> = Vec::new();
    let mut file = File::open(path)?;
    file.read_to_end(&mut buf)?;
    Ok(buf)
}

fn main() {
    file_per_thread_logger::initialize(LOG_FILENAME_PREFIX);

    let isa_builder = cranelift_native::builder().unwrap_or_else(|_| {
        panic!("host machine is not a supported target");
    });
    let mut flag_builder = settings::builder();

    // Enable verifier passes in debug mode.
    if cfg!(debug_assertions) {
        flag_builder.enable("enable_verifier").unwrap();
    }
    // flag_builder.set("opt_level", "best").unwrap();

    let isa = isa_builder.finish(settings::Flags::new(flag_builder));
    let mut compiler = Compiler::new(isa);
    let args: Vec<String> = args().collect();
    if args.len() < 2 {
        println!("Runtime expects a wasm binary or wat file as the first argument");
        exit(1);
    }
    let filename = args[1].clone();

    let path = Path::new(&filename);
    match handle_module(args, &mut compiler, path) {
        Ok(()) => {}
        Err(message) => {
            let name = path.as_os_str().to_string_lossy();
            println!("error while processing {}: {}", name, message);
            exit(1);
        }
    }
}

fn handle_module(args: Vec<String>, compiler: &mut Compiler, path: &Path) -> Result<(), String> {
    let mut data =
        read_to_end(path.to_path_buf()).map_err(|err| String::from(err.description()))?;
    // if data is using wat-format, first convert data to wasm
    if !data.starts_with(&[b'\0', b'a', b's', b'm']) {
        data = wabt::wat2wasm(data).map_err(|err| String::from(err.description()))?;
    }
    go::run(args, compiler, data)
}
