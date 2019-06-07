use http;
use wasabi_function;

fn main() {
    wasabi_function::handle_request(|_req: http::Request<Vec<u8>>| -> http::Response<Vec<u8>> {
        http::Response::builder()
            .status(200)
            .body(b"Hello, world!".to_vec())
            .unwrap()
    });
}
