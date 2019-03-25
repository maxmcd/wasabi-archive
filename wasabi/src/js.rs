use bytes;
use failure::{err_msg, Error};
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
    pub error_not_found: i64,
    pub true_value: i64,
    pub false_value: i64,
    pub null: i64,
    pub global: i64,
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

pub fn int_from_value(val: (i64, bool)) -> i64 {
    if val == (1, true) {
        0
    } else {
        val.0
    }
}

impl Js {
    pub fn new() -> Result<Self, Error> {
        let mut js = Self {
            slab: Slab::new(),
            static_strings: HashMap::new(),
            error_not_found: 2,
            true_value: 2,
            false_value: 2,
            null: 2,
            global: 2,
        };
        // These initial indexes must map up with Go's underlying assumptions
        // https://github.com/golang/go/blob/release-branch.go1.12/src/syscall/js/js.go#L75-L83
        // https://github.com/golang/go/blob/release-branch.go1.12/misc/wasm/wasm_exec.js#L370-L377
        js.slab_add(Value::NaN); //0 NaN
        js.slab_add(Value::Int(0)); //1 0
        js.slab_add(Value::Null); //2 null
        js.true_value = js.slab_add(Value::True); //3 true
        js.false_value = js.slab_add(Value::False); //4 false
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

        js.add_object(mem, "buffer")?;

        let fs = js.add_object(global, "fs")?;
        println!("{:?}", fs);
        js.add_object(fs, "write")?;
        js.add_object(fs, "open")?;
        js.add_object(fs, "stat")?;
        js.add_object(fs, "fstat")?;
        js.add_object(fs, "read")?;
        js.add_object(fs, "fsync")?;

        js.add_object(fs, "isDirectory")?;

        let constants = js.add_object(fs, "constants")?;

        // TODO: pass values from wasabi-io
        // https://github.com/golang/go/blob/release-branch.go1.12/src/syscall/syscall_js.go#L103-L112
        js.add_object_value(constants, "O_WRONLY", (1, false))?;
        js.add_object_value(constants, "O_RDWR", (2, false))?;
        js.add_object_value(constants, "O_CREAT", (64, false))?;
        js.add_object_value(constants, "O_TRUNC", (512, false))?;
        js.add_object_value(constants, "O_APPEND", (1024, false))?;
        js.add_object_value(constants, "O_EXCL", (128, false))?;

        let crypto = js.add_object(global, "crypto")?;
        js.add_object(crypto, "getRandomValues")?;

        // let pe = js.add_object(this, "_pendingEvent")?;
        js.add_object_value(this, "_pendingEvent", (2, true))?;
        // js.add_object_value(pe, "result", (2, true))?;
        js.add_object(this, "_makeFuncWrapper")?;

        js.add_object(global, "Object")?;
        js.add_object(global, "Array")?;

        js.add_object(global, "Uint8Array")?;
        js.add_object(global, "Int16Array")?;
        js.add_object(global, "Int32Array")?;
        js.add_object(global, "Int8Array")?;
        js.add_object(global, "Uint16Array")?;
        js.add_object(global, "Uint32Array")?;
        js.add_object(global, "Float32Array")?;
        js.add_object(global, "Float64Array")?;
        js.add_object(global, "process")?;
        js.add_object(global, "net_listener")?;

        let wsbi = js.add_object(global, "wasabi")?;
        js.add_object(wsbi, "lookup_ip")?;

        let date = js.add_object(global, "Date")?;
        // this would be a function on a new Date() but we'll just make it a
        // function on the global object to avoid allocating an item
        js.add_object(date, "getTimezoneOffset")?;

        let enoent = js.slab_add(Value::Object {
            name: "ENOENT",
            values: HashMap::new(),
        });
        let code = js.slab_add(Value::String(String::from("ENOENT")));
        js.add_object_value(enoent, "code", (code, true))?;
        js.error_not_found = enoent;

        js.global = global;

        js.static_strings.insert("is_directory", "is_directory");

        Ok(js)
    }
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
        if let Value::Object { name, .. } = self.slab_get(r)? {
            return Some(name);
        }
        None
    }
    pub fn add_object(&mut self, r: i64, name: &'static str) -> Result<i64, Error> {
        let new_r = self.slab.insert(Value::Object {
            name,
            values: HashMap::new(),
        }) as i64;
        self.add_object_value(r, name, (new_r, true))?;
        Ok(new_r)
    }
    pub fn add_array(
        &mut self,
        r: i64,
        name: &'static str,
        args: Vec<(i64, bool)>,
    ) -> Result<i64, Error> {
        let new_r = self.slab.insert(Value::Array(args)) as i64;
        self.add_object_value(r, name, (new_r, true))?;
        Ok(new_r)
    }
    pub fn add_object_value(
        &mut self,
        r: i64,
        name: &'static str,
        value: (i64, bool),
    ) -> Result<(), Error> {
        self.static_strings.insert(name, name);
        if let Some(o) = self.slab_get_mut(r) {
            if let Value::Object { values, .. } = o {
                values.insert(name, value);
                return Ok(());
            }
            return Err(err_msg("ref value is not an object"));
        }
        Err(err_msg("ref doesn't exist"))
    }
    pub fn value_length(&self, target: i64) -> Option<(i64)> {
        if let Value::Array(rs) = self.slab_get(target)? {
            return Some(rs.len() as i64);
        }
        None
    }
    pub fn reflect_get_index(&self, target: i64, property_key: i64) -> Option<(i64, bool)> {
        if let Value::Array(items) = self.slab_get(target)? {
            return Some(items[property_key as usize]);
        }
        None
    }
    pub fn reflect_get(&self, target: i64, property_key: &'static str) -> Option<(i64, bool)> {
        if let Value::Object { values, .. } = self.slab_get(target)? {
            let s = values.get(property_key)?;
            return Some(*s);
        };
        None
    }
    pub fn reflect_construct(
        &mut self,
        target: i64,
        argument_list: Vec<(i64, bool)>,
    ) -> Option<(i64, bool)> {
        let name = match self.slab_get(target)? {
            Value::Object { name, .. } => *name,
            _ => {
                return None;
            }
        };
        match name {
            "Uint8Array" => Some((
                self.slab_add(Value::Memory {
                    address: argument_list[1].0,
                    len: argument_list[2].0,
                }),
                true,
            )),
            "Date" => Some((target, true)),
            "net_listener" => {
                let nl = self.slab_add(Value::Object {
                    name: "net_listener",
                    values: HashMap::new(),
                });
                self.add_object(nl, "register").unwrap();
                Some((nl, true))
            }
            _ => None,
        }
    }
    pub fn reflect_set(
        &mut self,
        target: i64,
        property_key: &'static str,
        value: i64,
    ) -> Result<(), Error> {
        if let Some(o) = self.slab.get_mut(target as usize) {
            if let Value::Object { values, .. } = o {
                values.insert(property_key, (value, true));
                return Ok(());
            }
        };
        Err(err_msg("reflect_set target or property_key doesn't exist"))
    }
    pub fn add_metadata(&mut self, md: std::fs::Metadata) -> i64 {
        let is_dir = if md.is_dir() {
            self.true_value
        } else {
            self.false_value
        };
        let fstat = self.slab_add(Value::Object {
            name: "fstat",
            values: HashMap::new(),
        });
        self.add_object(fstat, "isDirectory").unwrap();
        self.add_object_value(fstat, "is_dir", (is_dir, true))
            .unwrap();
        fstat
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
        let big = (i32::MAX as i64) + 10; // 2147483657
        assert_eq!((big, false), load_value(&store_value((big, false))));

        // not for refs
        assert_eq!((-2147483639, true), load_value(&store_value((big, true))));
    }

    #[test]
    fn slab_get() {
        let j = Js::new().unwrap();
        match j.slab_get(0).unwrap() {
            Value::NaN => {}
            _ => {
                panic!("incorrect return value for slab_get");
            }
        }
    }

    #[test]
    fn test_reflect_get() {
        let j = Js::new().unwrap();
        assert_eq!(9, j.reflect_get(5, "fs").unwrap().0);
    }
    #[test]
    fn test_reflect_set() {
        let mut j = Js::new().unwrap();
        j.reflect_set(7, "_pendingEvent", 2).unwrap();
        assert_eq!(2, j.reflect_get(7, "_pendingEvent").unwrap().0);
        // println!("{:?}", MAX / 2);
    }

}
