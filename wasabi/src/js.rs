use bytes;
use pool::Pool;
use rand::{thread_rng, Rng};
use std::collections::HashMap;
use std::i32;

#[derive(Debug)]
enum Value {
    Array(Vec<(usize, bool)>),
    False,
    Int(i32),
    Int64(i64),
    Mem,
    Memory {
        address: i32,
        len: i32,
    },
    NaN,
    Null,
    Object {
        name: &'static str,
        values: HashMap<&'static str, (usize, bool)>,
    },
    String(String),
    True,
    Undefined,
}

struct Js {
    pool: Pool<Value>,
}

pub fn load_value(b: &[u8]) -> (usize, bool) {
    let float = f64::from_bits(bytes::as_i64_le(b) as u64);
    let intfloat = float as usize;
    if float == (intfloat) as f64 {
        //https://stackoverflow.com/questions/48500261/check-if-a-float-can-be-converted-to-integer-without-loss
        (intfloat, false)
    } else {
        (bytes::as_i32_le(b) as usize, true)
    }
}
pub fn store_value(r: (usize, bool)) -> [u8; 8] {
    let nan_head = 0x7FF80000;
    let mut out = [0; 8];
    if r.1 {
        out[0..4].copy_from_slice(&bytes::i32_as_u8_le(r.0 as i32));
        out[4..8].copy_from_slice(&bytes::i32_as_u8_le(nan_head));
        out
    } else {
        bytes::i64_as_u8_le((r.0 as f64).to_bits() as i64)
    }
}

impl Js {
    fn pool_add(&mut self, v: Value) -> usize {
        self.pool.add(v)
    }
    fn pool_get(&self, r: usize) -> Option<&Value> {
        self.pool.get(r)
    }
    fn add_object_to_ref(&mut self, r: usize, name: &'static str) -> usize {
        let new_r = self.pool.add(Value::Object {
            name: name,
            values: HashMap::new(),
        });
        if let Some(o) = self.pool.get_mut(r) {
            match o {
                Value::Object { values, .. } => {
                    values.insert(name, (new_r, true));
                    new_r
                }
                _ => {
                    panic!("ref value is not an object");
                }
            }
        } else {
            panic!("ref doesn't exist");
        }
    }
    fn reflect_get(&self, target: usize, property_key: &'static str) -> Option<(usize, bool)> {
        if let Some(o) = self.pool.get(target) {
            match o {
                Value::Object { values, .. } => {
                    if let Some(s) = values.get(property_key) {
                        Some(*s)
                    } else {
                        None
                    }
                }
                _ => None,
            }
        } else {
            None
        }
    }
    fn reflect_set(&mut self, target: usize, property_key: &'static str, value: usize) {
        if let Some(o) = self.pool.get_mut(target) {
            match o {
                Value::Object { values, .. } => {
                    values.insert(property_key, (value, true));
                }
                _ => {}
            }
        }
    }
    fn new() -> Self {
        let mut js = Self { pool: Pool::new() };
        // These initial indexes must map up with Go's underlying assumptions
        // https://github.com/golang/go/blob/8e50e48f4/src/syscall/js/js.go#L75-L83
        js.pool_add(Value::NaN); //0 NaN
        js.pool_add(Value::Int(0)); //1 0
        js.pool_add(Value::Null); //2 null
        js.pool_add(Value::True); //3 true
        js.pool_add(Value::False); //4 false
        let global = js.pool_add(Value::Object {
            name: "global",
            values: HashMap::new(),
        }); //5 global
        js.pool_add(Value::Mem); //6 this._inst.exports.mem
        let this = js.pool_add(Value::Object {
            name: "this",
            values: HashMap::new(),
        }); //7 this

        let fs = js.add_object_to_ref(global, "fs");
        js.add_object_to_ref(fs, "write");
        js.add_object_to_ref(fs, "open");
        js.add_object_to_ref(fs, "read");
        js.add_object_to_ref(fs, "fsync");

        let crypto = js.add_object_to_ref(global, "crypto");
        js.add_object_to_ref(crypto, "getRandomValues");

        js.add_object_to_ref(this, "_pendingEvent");

        js.add_object_to_ref(global, "Uint8Array");
        js.add_object_to_ref(global, "Date");
        js.add_object_to_ref(global, "net_listener");

        js
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn store_and_load_fuzz() {
        assert_eq!((42, false), load_value(&store_value((42, false))));
        assert_eq!((42, true), load_value(&store_value((42, true))));

        // greater than i32 is ok for numbers
        let big = (i32::MAX as usize) + 10; // 2147483657
        assert_eq!((big, false), load_value(&store_value((big, false))));

        // not for refs
        assert_eq!(
            (18446744071562067977, true),
            load_value(&store_value((big, true)))
        );

        // // fuzzz
        // loop {
        //     let mut data = [0; 8];
        //     thread_rng().fill(&mut data);
        //     let result = store_value(load_value(&data));
        //     if result[0..4] != data[0..4] {
        //         panic!("{:?}", data);
        //     }
        //     // 0x7FF80000
        //     if result[4..8] != [0, 0, 248, 127] {
        //         assert_eq!(result, data);
        //     }
        // }
    }

    #[test]
    fn pool_get() {
        let j = Js::new();
        match j.pool_get(0).unwrap() {
            Value::NaN => {}
            _ => {
                panic!("incorrect return value for pool_get");
            }
        }
    }

    #[test]
    fn test_reflect_get() {
        let j = Js::new();
        assert_eq!(8, j.reflect_get(5, "fs").unwrap().0);
    }
    #[test]
    fn test_reflect_set() {
        let mut j = Js::new();
        j.reflect_set(7, "_pendingEvent", 2);
        assert_eq!(2, j.reflect_get(7, "_pendingEvent").unwrap().0);
        // println!("{:?}", MAX / 2);
    }

}
