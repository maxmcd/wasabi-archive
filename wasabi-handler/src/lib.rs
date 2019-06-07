#[macro_use]
extern crate lazy_static;

use std::sync::Mutex;

type Callback = Mutex<Option<Box<FnMut(String, u32, Vec<u8>) + Send>>>;

lazy_static! {
    static ref CALLBACK: Callback = Mutex::new(None);
}

pub fn message_loop<F: 'static>(f: F)
where
    F: FnMut(String, u32, Vec<u8>) + Send,
{
    {
        let mut cb = CALLBACK.lock().unwrap();
        cb.replace(Box::new(f));
    }
}

pub struct Reference {
    pub reference: u32,
}

extern "C" {
    fn _send(name: *const u8, name_len: u32, reference: u32, payload: *const u8, payload_len: u32);
}

pub fn send(name: String, reference: u32, payload: Vec<u8>) -> Reference {
    unsafe {
        _send(
            name.as_ptr(),
            name.len() as u32,
            reference,
            payload.as_ptr(),
            payload.len() as u32,
        )
    };
    let x = rand::random::<u32>();
    Reference { reference: x }
}

#[no_mangle]
pub extern "C" fn start(_len: i32) {
    run()
}

fn run() {
    {
        let mut cb = CALLBACK.lock().unwrap();
        let mut f = cb.take().unwrap();
        f("hi".to_string(), 0, b"jo".to_vec());
        cb.replace(f);
    }

    {
        let mut cb = CALLBACK.lock().unwrap();
        let mut f = cb.take().unwrap();
        f("hi".to_string(), 0, b"jojo".to_vec());
        cb.replace(f);
    }
}
