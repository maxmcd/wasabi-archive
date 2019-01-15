extern crate cfg_if;

use cfg_if::cfg_if;

static mut GLOBAL_INT: i32 = 0;

cfg_if! {
    // When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
    // allocator.
    if #[cfg(feature = "wee_alloc")] {
        extern crate wee_alloc;
        #[global_allocator]
        static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;
    }
}
// use std::env;

#[no_mangle]
pub extern "C" fn main() -> i32 {
    // let path = env::current_dir().unwrap();
    // println!("The current directory is {}", path.display());
    // println!("Hello macro!");
    unsafe { GLOBAL_INT += 1 };
    let smsg = unsafe { format!("Hello world! {}", GLOBAL_INT) };
    let message = smsg.as_bytes();
    unsafe {
        println(message.as_ptr(), message.len());
    }
    0
}

extern "C" {
    pub fn alert(msg: *const u8, len: usize);
    pub fn println(msg: *const u8, len: usize);
}
