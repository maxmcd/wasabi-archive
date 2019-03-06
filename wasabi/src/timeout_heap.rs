use slab::Slab;
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

use std::{thread, time};
use util::epoch_ns;

#[derive(Debug, Eq)]
struct Timeout {
    time: i64,
    id: i32,
}

impl Timeout {
    fn ns_until_called(&self) -> u64 {
        let ns = epoch_ns();
        if self.time > ns {
            (self.time - ns) as u64
        } else {
            0
        }
    }
    fn time_until_called(&self) -> time::Duration {
        time::Duration::from_nanos(self.ns_until_called())
    }
    fn sleep_until_called(&self) {
        thread::sleep(self.time_until_called());
    }
}

impl Ord for Timeout {
    fn cmp(&self, other: &Self) -> Ordering {
        // min heap
        self.time.cmp(&other.time).reverse()
    }
}
impl PartialOrd for Timeout {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Timeout {
    fn eq(&self, other: &Self) -> bool {
        self.time == other.time && self.id == other.id
    }
}

#[derive(Debug)]
pub struct ToHeap {
    heap: BinaryHeap<Timeout>,
    slab: Slab<()>,
    map: HashMap<i32, ()>,
}

/// ToHeap stores timeouts and returns ids for them. Ids can be reused after
/// they are delete. This struct is a bit of a frankenstein to get around
/// implemeting a BinaryHeap with deletes. As we're just dealing with itegers
/// it's likely easy to dramatically simplify this implementation
impl ToHeap {
    pub fn new() -> Self {
        Self {
            heap: BinaryHeap::new(),
            slab: Slab::new(),
            map: HashMap::new(),
        }
    }
    pub fn add(&mut self, millis: i64) -> i32 {
        let id = self.slab.insert(()) as i32;
        self.map.insert(id, ());
        self.heap.push(Timeout {
            id,
            time: epoch_ns() + millis * 1_000_000,
        });
        id
    }
    pub fn remove(&mut self, id: i32) {
        self.map.remove(&id);
    }
    fn peek_id(&mut self) -> Option<usize> {
        Some(self.heap.peek()?.id as usize)
    }
    pub fn clean_timeouts(&mut self) {
        while let Some(id) = self.peek_id() {
            if self.map.contains_key(&(id as i32)) {
                break;
            } else {
                self.slab.remove(id);
                self.heap.pop();
            }
        }
    }
    pub fn is_empty(&self) -> bool {
        self.heap.is_empty()
    }
    fn peek(&mut self) -> Option<&Timeout> {
        self.clean_timeouts();
        self.heap.peek()
    }
    fn pop(&mut self) -> Option<Timeout> {
        self.clean_timeouts();
        self.heap.pop()
    }
    pub fn any_expired_timeouts(&mut self) -> bool {
        self.clean_timeouts();
        if self.is_empty() {
            return false;
        };
        if self.peek().unwrap().ns_until_called() != 0 {
            return false;
        };
        self.pop();
        true
    }
    pub fn duration_when_expired(&mut self) -> Option<time::Duration> {
        let to = self.peek()?;
        Some(to.time_until_called())
    }
    pub fn pop_when_expired(&mut self) -> Option<()> {
        let to = self.pop()?;
        to.sleep_until_called();
        Some(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::SystemTime;

    #[test]
    fn test_id_reuse() {
        let mut th = ToHeap::new();

        let id1 = th.add(1);
        th.add(2);

        th.remove(id1);
        th.clean_timeouts();

        let id3 = th.add(1);
        assert_eq!(id1, id3);
    }

    #[test]
    fn test_pop_expiration() {
        let mut th = ToHeap::new();

        th.add(2);
        th.add(2);
        assert_eq!(th.any_expired_timeouts(), false);

        let start = SystemTime::now();
        th.pop_when_expired();
        assert!(start.elapsed().unwrap() > time::Duration::from_millis(2));

        assert_eq!(th.any_expired_timeouts(), true);
    }
}
