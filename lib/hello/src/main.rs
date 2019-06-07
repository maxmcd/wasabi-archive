#![feature(start)]

extern crate serde;
extern crate serde_json;
extern crate wee_alloc;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Person {
    name: String,
    age: u8,
    phones: Vec<String>,
}

// Use `wee_alloc` as the global allocator.
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

extern "C" {
    fn puts(fmt: *const u8) -> i32;
}

fn main() {
    let data = r#"
            {
                "name": "John Doe",
                "age": 43,
                "phones": [
                    "+44 1234567",
                    "+44 2345678"
                ]
            }"#;

    let p: Person = serde_json::from_str(data).unwrap();

    unsafe { puts(format!("{:?}", p).as_bytes().as_ptr()) };
}

fn run(nw: FnMut()) {
    nw()
}

#[start]
fn start(_argc: isize, _argv: *const *const u8) -> isize {
    0
}

#[no_mangle]
pub extern "C" fn add_one(x: i32) -> i32 {
    x + 1
}
