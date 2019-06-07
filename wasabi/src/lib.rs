//! Runtime is a wasm go runtime

#![deny(
    // missing_docs,
    trivial_numeric_casts,
    unstable_features,
    unused_extern_crates,
    unused_features
)]
#![warn(unused_import_braces, unused_parens)]
#![cfg_attr(feature = "clippy", plugin(clippy(conf_file = "../../clippy.toml")))]
#![cfg_attr(
    feature = "cargo-clippy",
    allow(clippy::new_without_default, clippy::new_without_default)
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

pub mod bytes;
pub mod js;
pub mod timeout_heap;
pub mod util;

use std::sync::Mutex;

#[macro_use]
extern crate lazy_static;

pub struct Wasabi {
    pub js: js::Js,
    pub exited: bool,
    pub timeout_heap: timeout_heap::TimeoutHeap,
}

impl Default for Wasabi {
    fn default() -> Self {
        Self::new()
    }
}

impl Wasabi {
    pub fn new() -> Self {
        Self {
            js: js::Js::new().unwrap(),
            exited: false,
            timeout_heap: timeout_heap::TimeoutHeap::new(),
        }
    }

    pub fn process_event_loop(&mut self) -> Option<&'static str> {
        if self.timeout_heap.any_expired_timeouts() {
            return Some("go_scheduler");
        }
        // See if we can wait for a callback
        if self.timeout_heap.pop_when_expired().is_some() {
            return Some("go_scheduler");
        }
        None
    }
}

lazy_static! {
    pub static ref WASABI: Mutex<Wasabi> = Mutex::new(Wasabi::new());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn use_global() {
        let wasabi = WASABI.lock().unwrap();

        match wasabi.js.slab_get(0).unwrap() {
            js::Value::NaN => {}
            _ => {
                panic!("incorrect return value for slab_get");
            }
        }
    }

}
