use wasabi_handler;

fn main() {
    let mut count = 0;

    wasabi_handler::message_loop(move |from: String, reference: u32, msg: Vec<u8>| {
        println!("{:?}", msg);
        count += 1;
        wasabi_handler::send(
            from,
            reference,
            format!("Count is {:?}", count).as_bytes().to_vec(),
        );
    });
}
