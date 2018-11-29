extern crate cfg_if;

use cfg_if::cfg_if;

cfg_if! {
    // When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
    // allocator.
    if #[cfg(feature = "wee_alloc")] {
        extern crate wee_alloc;
        #[global_allocator]
        static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;
    }
}

#[no_mangle]
pub extern fn main() -> i32 {
    let message = "Hello world!".as_bytes();
    unsafe {
        println(message.as_ptr(), message.len());
    }
    0
}

extern "C" {
    pub fn alert(msg: *const u8, len: usize);
    pub fn println(msg: *const u8, len: usize);
}

