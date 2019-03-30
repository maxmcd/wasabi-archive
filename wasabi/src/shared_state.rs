use bytes::i32_as_u8_le;
use failure::Error;
use js;
use mem::{Actions, Mem};
use std::collections::{HashMap, VecDeque};
use std::net::IpAddr;
use timeout_heap::ToHeap;
use wasabi_io;
use wasabi_io::IOLoop;
use wasmtime_runtime::VMMemoryDefinition;

#[derive(Debug)]
pub struct SharedState {
    pub exited: bool,
    pub net_loop: IOLoop,
    pub net_callback_id: i64,
    pub timeout_heap: ToHeap,
    pub call_queue: VecDeque<i64>,
    pub js: js::Js,
    pub mem: Mem,
}

impl SharedState {
    pub fn new() -> Self {
        Self {
            timeout_heap: ToHeap::new(),
            exited: false,
            mem: Mem::new(),
            net_loop: IOLoop::new(),
            net_callback_id: 0,
            js: js::Js::new().unwrap(),
            call_queue: VecDeque::new(),
        }
    }
    pub fn add_definition(&mut self, def: *mut VMMemoryDefinition) {
        self.mem.definition = Some(def);
    }
    pub fn store_string(&mut self, address: i32, val: String) {
        let reference = self.store_value_bytes(val.into_bytes());
        self.mem.set_i32(address, reference);
    }
    pub fn load_value(&self, address: i32) -> (i64, bool) {
        let addru = address as usize;
        js::load_value(&self.mem.mem_slice(addru, addru + 8))
    }
    fn _set_byte_array_array(&mut self, values: Vec<Vec<u8>>) -> i32 {
        let mut byte_references = vec![0; values.len() * 4];
        for (i, value) in values.iter().enumerate() {
            let reference = self.store_value_bytes(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&i32_as_u8_le(reference));
        }
        self.store_value_bytes(byte_references)
    }
    pub fn set_byte_array_array(&mut self, addr: i32, values: Vec<Vec<u8>>) {
        let reference = self._set_byte_array_array(values);
        self.mem.set_i32(addr, reference);
    }
    pub fn set_usize_result(&mut self, addr: i32, result: Result<usize, Error>) {
        match result {
            Ok(value) => {
                self.mem.set_i32(addr, value as i32);
                self.mem.set_bool(addr + 4, true);
            }
            Err(err) => {
                self.set_error(addr, &err);
                self.mem.set_bool(addr + 4, false);
            }
        }
    }
    pub fn set_error(&mut self, addr: i32, err: &Error) {
        self.store_string(addr, err.to_string())
    }
    pub fn store_value(&mut self, addr: i32, jsv: (i64, bool)) {
        let b = js::store_value(jsv);
        let addru = addr as usize;
        self.mem.mut_mem_slice(addru, addru + 8).copy_from_slice(&b)
    }
    pub fn load_slice_of_values(&self, address: i32) -> Vec<(i64, bool)> {
        let mut out = Vec::new();
        let array = self.mem.get_i32(address);
        let len = self.mem.get_i32(address + 8);
        for n in 0..len {
            out.push(self.load_value(array + n * 8))
        }
        out
    }
    pub fn store_value_bytes(&mut self, b: Vec<u8>) -> i32 {
        self.js.slab_add(js::Value::Bytes(b)) as i32
    }
    fn recv_net_events(&mut self) -> Option<Vec<wasabi_io::Response>> {
        let mut events = Vec::new();

        // We have to clear them before we do the empty check below
        self.timeout_heap.clean_timeouts();

        // If there's nothing at all to be called, wait for network events
        if self.call_queue.is_empty() && self.timeout_heap.is_empty() {
            events.push(self.net_loop.recv().unwrap());

        // If the timeout heap has candidates only wait on the recv until
        // the next timeout
        } else if self.call_queue.is_empty() && !self.timeout_heap.is_empty() {
            let duration = self.timeout_heap.duration_when_expired().unwrap();
            if let Ok(event) = self.net_loop.recv_timeout(duration) {
                events.push(event)
            }
        }

        // Run a try_recv loop to drain events regardless of how we got here
        while let Ok(event) = self.net_loop.try_recv() {
            events.push(event)
        }

        if events.is_empty() {
            None
        } else {
            Some(events)
        }
    }
    fn add_pending_event(&mut self, id: i64, args: Vec<(i64, bool)>) {
        // TODO: return result
        let pe = self.js.slab_add(js::Value::Object {
            name: "pending_event",
            values: HashMap::new(),
        });
        self.js.add_object_value(pe, "id", (id, false)).unwrap();
        self.js.add_object_value(pe, "result", (2, true)).unwrap();
        self.js.add_object(pe, "this").unwrap();
        self.js.add_array(pe, "args", args).unwrap();
        self.call_queue.push_back(pe);
    }
    pub fn process_event_loop(&mut self) -> Result<bool, Error> {
        // Stop execution if we've exited
        if self.exited {
            return Ok(true);
        }
        // Check for events if we have an active listener
        if self.net_loop.is_active() {
            if let Some(events) = self.recv_net_events() {
                let mut network_cb_args = Vec::new();
                for event in events {
                    if event.id().is_some() {
                        self.js
                            .add_object_value(event.id().unwrap(), "result", (2, true))
                            .unwrap();
                        self.call_queue.push_back(event.id().unwrap());
                    }
                    match event {
                        wasabi_io::Response::Event(event) => {
                            let ints = wasabi_io::event_to_ints(&event);
                            network_cb_args.push((ints.0, false));
                            network_cb_args.push((ints.1, false));
                        }
                        wasabi_io::Response::Success { id } => {
                            self.js.add_array(id, "args", vec![(2, true)]).unwrap();
                        }
                        wasabi_io::Response::Written { id, len } => {
                            self.js
                                .add_array(id, "args", vec![(2, true), (len as i64, false)])
                                .unwrap();
                        }
                        wasabi_io::Response::Ips { id, ips } => {
                            let mut byte_ips: Vec<Vec<u8>> = Vec::new();
                            for ip in ips.iter() {
                                match ip {
                                    IpAddr::V4(ip4) => byte_ips.push(ip4.octets().to_vec()),
                                    IpAddr::V6(_) => {} //no IPV6 support
                                }
                            }
                            let reference = self._set_byte_array_array(byte_ips);
                            self.js
                                .add_array(
                                    id,
                                    "args",
                                    vec![(2, true), (i64::from(reference), false)],
                                )
                                .unwrap();
                        }
                        wasabi_io::Response::Read {
                            buf,
                            id,
                            len,
                            address,
                        } => {
                            self.mem
                                .mut_mem_slice(address, address + len)
                                .clone_from_slice(&buf[..len]);
                            self.js
                                .add_array(
                                    id,
                                    "args",
                                    vec![(2, true), (len as i64, false), (2, true)],
                                )
                                .unwrap();
                        }
                        wasabi_io::Response::Metadata { id, md } => {
                            let fstat = self.js.add_metadata(md).unwrap();
                            self.js
                                .add_array(id, "args", vec![(2, true), (fstat, true)])
                                .unwrap();
                        }
                        wasabi_io::Response::FileRef { id, fd } => {
                            self.js
                                .add_array(id, "args", vec![(2, true), ((fd as i64), false)])
                                .unwrap();
                        }
                        wasabi_io::Response::Error { id, kind, .. } => match kind {
                            std::io::ErrorKind::AlreadyExists => {
                                let eexist = self.js.error_exists;
                                self.js.add_array(id, "args", vec![(eexist, true)]).unwrap();
                            }
                            std::io::ErrorKind::NotFound => {
                                let enoent = self.js.error_not_found;
                                self.js.add_array(id, "args", vec![(enoent, true)]).unwrap();
                            }
                            _ => {
                                println!("unhandled error type {:?}", kind);
                            }
                        },
                        _ => {
                            println!("unhandled event {:?}", event);
                        }
                    }
                }
                if !network_cb_args.is_empty() {
                    // Add the network callback to the call stack
                    let ncbid = self.net_callback_id;
                    self.add_pending_event(ncbid, network_cb_args);
                }
            }
        }

        // Check if any timeouts have expired.
        if self.timeout_heap.any_expired_timeouts() {
            return Ok(false);
        }

        // Invoke an event by setting it as the this._pendingEvent
        if !self.call_queue.is_empty() {
            self.js
                .add_object_value(
                    7,
                    "_pendingEvent",
                    (self.call_queue.pop_front().unwrap(), true),
                )
                .unwrap();
            return Ok(false);
        }

        // See if we can wait for a callback
        if self.timeout_heap.pop_when_expired().is_some() {
            return Ok(false);
        }

        // If we get this far we've run out of things to do, but the program
        // hasn't exited normally. Set pending event to 0 to trigger a stack
        // dump and exit
        if !self.exited {
            self.exited = true;
            self.add_pending_event(0, Vec::new());
            return Ok(false);
        }

        Ok(true)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time;
    use std::time::SystemTime;

    #[test]
    fn test_event_loop_empty() {
        let mut ss = SharedState::new();

        // no events so the program adds a pending event with id 0
        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, false);
        assert_eq!(ss.call_queue.len(), 1);
        let reference = ss.call_queue.pop_front().unwrap();

        if let js::Value::Object { name, values } = ss.js.slab_get(reference).unwrap() {
            assert_eq!(name, &"pending_event");
            assert_eq!(values["id"].0, 0);
        } else {
            panic!("ref should be an object");
        }

        // now we're exited, so it should break
        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, true);
    }

    // #[test]
    // fn test_event_loop_timeouts() {
    //     let mut ss = SharedState::new();
    // }

    #[test]
    fn test_event_loop_only_callback() {
        // TODO: there are two timeout points, we were flipping is_listening but that's
        // now gone. re-add a way to test both timeout

        let mut ss = SharedState::new();
        let ms = 2;
        ss.timeout_heap.add(ms);

        let should_break = ss.process_event_loop().unwrap();
        assert_eq!(should_break, false);
        assert!(ss.timeout_heap.is_empty());

        let ms_2 = 15;
        ss.timeout_heap.add(ms_2);

        let to_cancel_id = ss.timeout_heap.add(12);

        let ms = 5;
        ss.timeout_heap.add(ms);

        let timeout_timer = SystemTime::now();
        let should_break = ss.process_event_loop().unwrap();
        println!("{:?}", timeout_timer.elapsed().unwrap());
        assert!(timeout_timer.elapsed().unwrap() > time::Duration::from_millis(ms as u64));
        assert_eq!(should_break, false);

        ss.add_pending_event(4, vec![]);
        ss.process_event_loop().unwrap();
        assert!(ss.call_queue.is_empty());

        ss.timeout_heap.remove(to_cancel_id);

        let should_break = ss.process_event_loop().unwrap();
        println!("{:?}", timeout_timer.elapsed().unwrap());
        assert!(timeout_timer.elapsed().unwrap() > time::Duration::from_millis(ms_2 as u64));
        assert_eq!(should_break, false);
    }

}
