use pool::Pool;
use std::collections::HashMap;
use std::i32::MAX;

#[derive(Debug)]
enum Value {
    Array([i32; 8]),
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
        values: HashMap<&'static str, usize>,
    },
    True,
    Undefined,
}

struct Js {
    pool: Pool<Value>,
}

impl Js {
    fn add_object_to_ref(&mut self, r: usize, name: &'static str) -> usize {
        let new_r = self.pool.add(Value::Object {
            name: name,
            values: HashMap::new(),
        });
        if let Some(o) = self.pool.get_mut(r) {
            match o {
                Value::Object { values, .. } => {
                    values.insert(name, new_r);
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
    fn reflect_get(&self, target: usize, property_key: &'static str) -> Option<usize> {
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
                    values.insert(property_key, value);
                }
                _ => {}
            }
        }
    }
    fn new() -> Self {
        let mut pool = Pool::new();
        // These initial indexes must map up with Go's underlying assumptions
        pool.add(Value::NaN); //0
        pool.add(Value::Int(0)); //1
        pool.add(Value::Null); //2
        pool.add(Value::True); //3
        pool.add(Value::False); //4
        let global = pool.add(Value::Object {
            name: "global",
            values: HashMap::new(),
        }); //5
        pool.add(Value::Mem); //6
        let this = pool.add(Value::Object {
            name: "this",
            values: HashMap::new(),
        }); //7

        let mut js = Self { pool };

        let fs = js.add_object_to_ref(global, "fs");
        js.add_object_to_ref(fs, "write");
        js.add_object_to_ref(fs, "open");
        js.add_object_to_ref(fs, "read");
        js.add_object_to_ref(fs, "fsync");

        let crypto = js.add_object_to_ref(global, "crypto");
        js.add_object_to_ref(crypto, "getRandomValues");

        js.add_object_to_ref(this, "_pendingEvent");

        js
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reflect_get() {
        let j = Js::new();
        assert_eq!(8, j.reflect_get(5, "fs").unwrap());
    }
    #[test]
    fn test_reflect_set() {
        let mut j = Js::new();
        j.reflect_set(7, "_pendingEvent", 2);
        assert_eq!(2, j.reflect_get(7, "_pendingEvent").unwrap());
        // println!("{:?}", MAX / 2);
    }

}
