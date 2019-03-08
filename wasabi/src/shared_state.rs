use failure::Error;
use js;
use network;
use network::NetLoop;
use std::collections::{HashMap, VecDeque};
use std::slice;
use timeout_heap::ToHeap;
use wasmtime_runtime::VMMemoryDefinition;

#[derive(Debug)]
pub struct Mem {
    definition: Option<*mut VMMemoryDefinition>,
}
impl Mem {
    fn new() -> Self {
        Self { definition: None }
    }
    pub fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition.unwrap();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
    }
    pub fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
        unsafe {
            let memory_def = &*self.definition.unwrap();
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..end]
        }
    }
}

#[derive(Debug)]
pub struct SharedState {
    pub exited: bool,
    pub net_loop: NetLoop,
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
            net_loop: NetLoop::new(),
            net_callback_id: 0,
            js: js::Js::new().unwrap(),
            call_queue: VecDeque::new(),
        }
    }
    pub fn add_definition(&mut self, def: *mut VMMemoryDefinition) {
        self.mem.definition = Some(def);
    }
    pub fn definition(&self) -> *mut VMMemoryDefinition {
        self.mem.definition.unwrap()
    }
    fn recv_net_events(&mut self) -> Option<Vec<mio::event::Event>> {
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
        if self.net_loop.is_listening {
            if let Some(events) = self.recv_net_events() {
                let mut network_cb_args = Vec::new();
                for event in &events {
                    let ints = network::event_to_ints(event);
                    network_cb_args.push((ints.0, false));
                    network_cb_args.push((ints.1, false));
                }
                // Add the network callback to the call stack
                let ncbid = self.net_callback_id;
                self.add_pending_event(ncbid, network_cb_args);
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
        let mut ss = SharedState::new();
        for is_listening in vec![true, false] {
            ss.net_loop.is_listening = is_listening;

            let ms = 2;
            ss.timeout_heap.add(ms);

            let should_break = ss.process_event_loop().unwrap();
            assert_eq!(should_break, false);
            assert!(ss.timeout_heap.is_empty());

            let ms_2 = 15;
            ss.timeout_heap.add(ms_2);

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

            let should_break = ss.process_event_loop().unwrap();
            println!("{:?}", timeout_timer.elapsed().unwrap());
            assert!(timeout_timer.elapsed().unwrap() > time::Duration::from_millis(ms_2 as u64));
            assert_eq!(should_break, false);
        }
    }

}
