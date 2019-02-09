use bytes;
use slab::Slab;
use std::collections::HashMap;
use std::i32;

#[derive(Debug)]
pub enum Value {
    Array(Vec<(i64, bool)>),
    False,
    Int(i32),
    Memory {
        address: i64,
        len: i64,
    },
    NaN,
    Null,
    Object {
        name: &'static str,
        // the i64 is a ref or integer
        // the bool is "is this a ref"
        // See load_value and store_value
        values: HashMap<&'static str, (i64, bool)>,
    },
    String(String),
    Bytes(Vec<u8>),
    True,
}

#[derive(Debug)]
pub struct Js {
    slab: Slab<Value>,
    pub static_strings: HashMap<&'static str, &'static str>,
}

pub fn load_value(b: &[u8]) -> (i64, bool) {
    #![allow(clippy::float_cmp)]

    let float = f64::from_bits(bytes::as_i64_le(b) as u64);
    let intfloat = float as i64;

    if float == (intfloat) as f64 {
        //https://stackoverflow.com/questions/48500261/check-if-a-float-can-be-converted-to-integer-without-loss
        (intfloat, false)
    } else {
        (i64::from(bytes::as_i32_le(b)), true)
    }
}
pub fn store_value(r: (i64, bool)) -> [u8; 8] {
    let nan_head = 0x7FF8_0000;
    let mut out = [0; 8];
    if r.1 {
        out[0..4].copy_from_slice(&bytes::i32_as_u8_le(r.0 as i32));
        out[4..8].copy_from_slice(&bytes::i32_as_u8_le(nan_head));
        out
    } else if r.0 == 0 {
        out[0..4].copy_from_slice(&bytes::i32_as_u8_le(1));
        out[4..8].copy_from_slice(&bytes::i32_as_u8_le(nan_head));
        out
    } else {
        bytes::i64_as_u8_le((r.0 as f64).to_bits() as i64)
    }
}

impl Js {
    pub fn slab_add(&mut self, v: Value) -> i64 {
        self.slab.insert(v) as i64
    }
    pub fn slab_get(&self, r: i64) -> Option<&Value> {
        self.slab.get(r as usize)
    }
    pub fn slab_get_mut(&mut self, r: i64) -> Option<&mut Value> {
        self.slab.get_mut(r as usize)
    }
    pub fn get_object_name(&self, r: i64) -> Option<&'static str> {
        match self.slab_get(r) {
            Some(o) => match o {
                Value::Object { name, .. } => Some(name),
                _ => None,
            },
            None => None,
        }
    }
    pub fn add_object(&mut self, r: i64, name: &'static str) -> i64 {
        self.static_strings.insert(name, name);
        let new_r = self.slab.insert(Value::Object {
            name,
            values: HashMap::new(),
        }) as i64;
        if let Some(o) = self.slab_get_mut(r) {
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
    pub fn add_array(&mut self, r: i64, name: &'static str, args: Vec<(i64, bool)>) -> i64 {
        self.static_strings.insert(name, name);
        let new_r = self.slab.insert(Value::Array(args)) as i64;
        if let Some(o) = self.slab_get_mut(r) {
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
    pub fn add_object_value(&mut self, r: i64, name: &'static str, value: (i64, bool)) {
        self.static_strings.insert(name, name);
        if let Some(o) = self.slab_get_mut(r) {
            match o {
                Value::Object { values, .. } => {
                    values.insert(name, value);
                }
                _ => {
                    panic!("ref value is not an object");
                }
            }
        } else {
            panic!("ref doesn't exist");
        }
    }
    pub fn value_length(&self, target: i64) -> Option<(i64)> {
        if let Some(v) = self.slab_get(target) {
            match v {
                Value::Array(rs) => Some(rs.len() as i64),
                _ => None,
            }
        } else {
            None
        }
    }
    pub fn reflect_get_index(&self, target: i64, property_key: i64) -> Option<(i64, bool)> {
        if let Some(o) = self.slab_get(target) {
            match o {
                Value::Array(items) => Some(items[property_key as usize]),
                _ => None,
            }
        } else {
            None
        }
    }
    pub fn reflect_get(&self, target: i64, property_key: &'static str) -> Option<(i64, bool)> {
        if let Some(o) = self.slab_get(target) {
            match o {
                Value::Object { values, .. } => {
                    if let Some(s) = values.get(property_key) {
                        Some(*s)
                    } else {
                        None
                    }
                }
                // Value::Mem => {}
                _ => None,
            }
        } else {
            None
        }
    }
    pub fn reflect_construct(
        &mut self,
        target: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        // TODO: don't pass around arbitrary ints as references within a function
        let name = match self.slab_get(target) {
            Some(o) => match o {
                Value::Object { name, .. } => match *name {
                    "Uint8Array" => Some(0),
                    "Date" => Some(1),
                    "net_listener" => Some(2),
                    _ => None,
                },
                _ => None,
            },
            None => None,
        };
        match name {
            Some(key) => match key {
                0 => Some((
                    self.slab_add(Value::Memory {
                        address: argument_list[1].0,
                        len: argument_list[2].0,
                    }),
                    true,
                )), //Uint8Array
                1 => Some((target, true)), //Date
                2 => {
                    let nl = self.slab_add(Value::Object {
                        name: "net_listener",
                        values: HashMap::new(),
                    });
                    self.add_object(nl, "register");
                    Some((nl, true))
                } //net_listener
                _ => None,
            },
            None => None,
        }
    }
    pub fn reflect_set(&mut self, target: i64, property_key: &'static str, value: i64) {
        if let Some(o) = self.slab.get_mut(target as usize) {
            if let Value::Object { values, .. } = o {
                values.insert(property_key, (value, true));
            }
        }
    }
    pub fn new() -> Self {
        let mut js = Self {
            slab: Slab::new(),
            static_strings: HashMap::new(),
        };
        // These initial indexes must map up with Go's underlying assumptions
        // https://github.com/golang/go/blob/8e50e48f4/src/syscall/js/js.go#L75-L83
        js.slab_add(Value::NaN); //0 NaN
        js.slab_add(Value::Int(0)); //1 0
        js.slab_add(Value::Null); //2 null
        js.slab_add(Value::True); //3 true
        js.slab_add(Value::False); //4 false
        let global = js.slab_add(Value::Object {
            name: "global",
            values: HashMap::new(),
        }); //5 global
        let mem = js.slab_add(Value::Object {
            name: "mem",
            values: HashMap::new(),
        }); //6 this._inst.exports.mem
        let this = js.slab_add(Value::Object {
            name: "this",
            values: HashMap::new(),
        }); //7 this

        js.add_object(mem, "buffer");

        let fs = js.add_object(global, "fs");
        js.add_object(fs, "write");
        js.add_object(fs, "open");
        js.add_object(fs, "read");
        js.add_object(fs, "fsync");
        let constants = js.add_object(fs, "constants");

        js.add_object_value(constants, "O_WRONLY", (-1, false));
        js.add_object_value(constants, "O_RDWR", (-1, false));
        js.add_object_value(constants, "O_CREAT", (-1, false));
        js.add_object_value(constants, "O_TRUNC", (-1, false));
        js.add_object_value(constants, "O_APPEND", (-1, false));
        js.add_object_value(constants, "O_EXCL", (-1, false));

        let crypto = js.add_object(global, "crypto");
        js.add_object(crypto, "getRandomValues");

        let pe = js.add_object(this, "_pendingEvent");
        js.add_object_value(pe, "result", (2, true));
        js.add_object(this, "_makeFuncWrapper");

        js.add_object(global, "Object");
        js.add_object(global, "Array");

        js.add_object(global, "Uint8Array");
        js.add_object(global, "Int16Array");
        js.add_object(global, "Int32Array");
        js.add_object(global, "Int8Array");
        js.add_object(global, "Uint16Array");
        js.add_object(global, "Uint32Array");
        js.add_object(global, "Float32Array");
        js.add_object(global, "Float64Array");
        js.add_object(global, "process");
        js.add_object(global, "net_listener");

        let date = js.add_object(global, "Date");
        // this would be a function on a new Date() but we'll just make it a
        // function on the global object to avoid allocating a item
        js.add_object(date, "getTimezoneOffset");

        js
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    // use rand::{thread_rng, Rng};

    #[test]
    fn store_and_load_fuzz() {
        assert_eq!((42, false), load_value(&store_value((42, false))));
        assert_eq!((42, true), load_value(&store_value((42, true))));

        // greater than i32 is ok for numbers
        let big = (i32::MAX as i64) + 10; // 2147483657
        assert_eq!((big, false), load_value(&store_value((big, false))));

        // not for refs
        assert_eq!((-2147483639, true), load_value(&store_value((big, true))));

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
    fn slab_get() {
        let j = Js::new();
        match j.slab_get(0).unwrap() {
            Value::NaN => {}
            _ => {
                panic!("incorrect return value for slab_get");
            }
        }
    }

    #[test]
    fn test_reflect_get() {
        let j = Js::new();
        assert_eq!(9, j.reflect_get(5, "fs").unwrap().0);
    }
    #[test]
    fn test_reflect_set() {
        let mut j = Js::new();
        j.reflect_set(7, "_pendingEvent", 2);
        assert_eq!(2, j.reflect_get(7, "_pendingEvent").unwrap().0);
        // println!("{:?}", MAX / 2);
    }

}
