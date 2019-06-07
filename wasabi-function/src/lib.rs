#[macro_use]
extern crate lazy_static;
extern crate http;

use std::sync::Mutex;

type Callback = Mutex<Option<Box<FnMut(String, u32, Vec<u8>) + Send>>>;

lazy_static! {
    static ref CALLBACK: Callback = Mutex::new(None);
}

pub fn handle_request<F: 'static>(mut f: F)
where
    F: FnMut(http::Request<Vec<u8>>) -> http::Response<Vec<u8>>,
{
    let body = b"hi".to_vec();
    let request = http::Request::builder().body(body).unwrap();
    let resp = f(request);
    println!("resp: {:?}", resp);
}
