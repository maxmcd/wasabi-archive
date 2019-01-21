use bytes::{as_i32_le, as_i64_le, i32_as_u8_le, i64_as_u8_le, u32_as_u8_le};
use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use js;
use mio;
use mio::net::TcpListener;
use rand::{thread_rng, Rng};
use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::io::Read;
use std::net::{IpAddr, ToSocketAddrs};
use std::rc::Rc;
use std::slice;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{str, thread, time};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::{
    instantiate, ActionOutcome, Compiler, InstantiationError, Namespace, RuntimeValue,
};
use wasmtime_runtime::{Imports, Instance, VMContext, VMFunctionBody, VMMemoryDefinition};

#[derive(Debug)]
enum JsValue {
    Array(Vec<JsValue>),
    Bytes(Vec<u8>),
    False,
    FuncWrapper {
        id: i32,
    },
    Global,
    Int(i32),
    Int64(i64),
    Mem,
    Memory {
        address: i32,
        len: i32,
    },
    NaN,
    NetListener,
    Null,
    Object {
        name: &'static str,
        values: HashMap<&'static str, i32>,
    },
    PendingEvent {
        id: i32,
        args: Option<Vec<JsValue>>,
    },
    String(String),
    This,
    True,
    Undefined,
}

#[derive(Debug, Eq)]
struct Callback {
    time: i64,
    id: i32,
}

impl Ord for Callback {
    fn cmp(&self, other: &Callback) -> Ordering {
        self.time.cmp(&other.time)
    }
}
impl PartialOrd for Callback {
    fn partial_cmp(&self, other: &Callback) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Callback {
    fn eq(&self, other: &Callback) -> bool {
        self.time == other.time && self.id == other.id
    }
}

#[derive(Debug)]
struct NetPool {
    pointer: usize,
    items: Vec<Option<NetTcp>>,
}

impl NetPool {
    fn new() -> Self {
        Self {
            pointer: 0,
            items: Vec::new(),
        }
    }
    fn add(&mut self, nt: NetTcp) -> usize {
        let id = self.pointer;
        if self.pointer == self.items.len() {
            self.items.push(Some(nt));
            self.pointer += 1;
        } else {
            self.items[self.pointer] = Some(nt);
            for ref item in self.items[self.pointer + 1..].iter() {
                self.pointer += 1;
                match item {
                    None => {
                        return self.pointer;
                    }
                    _ => {}
                }
            }
        }
        id
    }
    fn next_id(&self) -> usize {
        self.pointer
    }
    fn get(&self, i: usize) -> Option<&Option<NetTcp>> {
        self.items.get(i)
    }
    fn get_ref(&self, i: usize) -> Option<&NetTcp> {
        match self.items.get(i) {
            Some(ontcp) => match ontcp {
                Some(ntcp) => Some(ntcp),
                None => None,
            },
            None => None,
        }
    }
    fn get_listener_ref(&self, i: usize) -> Option<&mio::net::TcpListener> {
        match self.get_ref(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Listener(listener) => Some(&listener),
                _ => None,
            },
            None => None,
        }
    }
    fn get_stream_ref(&self, i: usize) -> Option<&mio::net::TcpStream> {
        match self.get_ref(i) {
            Some(ntcp) => match ntcp {
                NetTcp::Stream(s) => Some(&s),
                _ => None,
            },
            None => None,
        }
    }
    fn is_empty(&self) -> bool {
        self.pointer == 0
    }
    fn remove(&mut self, i: usize) {
        if i > self.items.len() {
            panic!("index out of range")
        }
        self.items.remove(i);
        if i < self.pointer {
            self.pointer = i
        }
    }
}

#[derive(Debug)]
enum NetTcp {
    Listener(mio::net::TcpListener),
    Stream(mio::net::TcpStream),
}

#[derive(Debug)]
struct SharedState {
    definition: Option<*mut VMMemoryDefinition>,
    values: Vec<JsValue>,
    pending_event_ref: i32,
    exited: bool,
    poll: mio::Poll,
    net_pool: NetPool,
    net_callback_id: i32,
    next_callback_timeout_id: i32,
    callback_heap: BinaryHeap<Callback>,
    callback_map: HashMap<i32, bool>,
}

impl SharedState {
    fn new() -> Self {
        let mut ss = Self {
            callback_heap: BinaryHeap::new(),
            callback_map: HashMap::new(),
            definition: None,
            exited: false,
            poll: mio::Poll::new().unwrap(),
            net_pool: NetPool::new(),
            net_callback_id: 0,
            next_callback_timeout_id: 1,
            pending_event_ref: 0,
            values: vec![
                JsValue::NaN,    //0 NaN,
                JsValue::Int(0), //1 0,
                JsValue::Null,   //2 null,
                JsValue::True,   //3 true,
                JsValue::False,  //4 false,
                JsValue::Object {
                    name: "global",
                    values: [("fs", 8), ("Date", 9), ("Crypto", 10)]
                        .iter()
                        .cloned()
                        .collect(),
                }, //5 global,
                JsValue::Mem,    //6 this._inst.exports.mem,
                JsValue::This,   //7 this,
            ],
        };
        let fs = JsValue::Object {
            name: "fs",
            values: [("write", -1)].iter().cloned().collect(),
        };
        ss.add_value(fs);
        ss
    }
    fn add_value(&mut self, value: JsValue) -> i32 {
        let reference = self.values.len();
        self.values.push(value);
        reference as i32
    }
    fn add_pending_event(&mut self, id: i32, args: Option<Vec<JsValue>>) {
        let pending_event = JsValue::PendingEvent { id: id, args: args };
        let reference = self.values.len();
        self.values.push(pending_event);
        self.pending_event_ref = reference as i32;
    }
}

struct FuncContext {
    vmctx: *mut VMContext,
}
impl FuncContext {
    fn new(vmctx: *mut VMContext) -> Self {
        Self { vmctx: vmctx }
    }
}

impl ContextHelpers for FuncContext {
    fn shared_state(&self) -> &mut SharedState {
        unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
    }
    fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
        unsafe {
            let memory_def = &*self.definition();
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..end]
        }
    }
}

trait ContextHelpers {
    fn shared_state(&self) -> &mut SharedState;
    fn definition(&self) -> *mut VMMemoryDefinition {
        self.shared_state().definition.unwrap()
    }
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8];
    fn mem_slice(&self, start: usize, end: usize) -> &[u8];
    fn values(&self) -> &mut Vec<JsValue> {
        &mut self.shared_state().values
    }
    fn reflect_get(&self, target: &JsValue, property_key: &JsValue) -> JsValue {
        match (target, property_key) {
            (JsValue::Global, JsValue::String(s)) => JsValue::String(s.to_string()),
            (JsValue::String(t), JsValue::String(pk)) => match (t.as_ref(), pk.as_ref()) {
                ("fs", "constants") => JsValue::String("fs.constants".to_string()),
                ("fs", "write") => JsValue::String("fs.write".to_string()),
                ("Date", "getTimezoneOffset") => {
                    JsValue::String("Date.getTimezoneOffset".to_string())
                }
                ("crypto", "getRandomValues") => {
                    JsValue::String("crypto.getRandomValues".to_string())
                } // Always UTC
                ("fs.constants", _) => {
                    JsValue::Int(-1)
                    // wasm_exec.js:42
                    // constants: {
                    //     O_WRONLY: -1, O_RDWR: -1, O_CREAT: -1,
                    //     O_TRUNC: -1, O_APPEND: -1, O_EXCL: -1 },
                    // unused
                }
                _ => {
                    panic!("Not implemented {:?} {:?}", target, property_key);
                }
            },
            (JsValue::PendingEvent { id, args }, JsValue::String(a)) => match a.as_ref() {
                "id" => JsValue::Int(*id),
                "this" => JsValue::This,
                "args" => {
                    // if let Some(args) = args.take() {
                    //     JsValue::Array(args)
                    // } else {
                    JsValue::Array(vec![])
                    // }
                }
                _ => {
                    panic!("Not implemented {:?} {:?}", target, property_key);
                }
            },
            (JsValue::Mem, JsValue::String(_pk)) => {
                // mem.buffer
                JsValue::String("mem.buffer".to_string())
            }
            (JsValue::NetListener, _) => JsValue::NetListener,
            (JsValue::This, JsValue::String(s)) => {
                if s == "_pendingEvent" && self.shared_state().pending_event_ref == 0 {
                    JsValue::Null
                } else if s == "_pendingEvent" {
                    let pe = self
                        .shared_state()
                        .values
                        .get(self.shared_state().pending_event_ref as usize);
                    if let Some(pe) = pe {
                        match pe {
                            // JsValue::Null
                            // JsValue::PendingEvent { id, args } => JsValue::PendingEvent {
                            //     id: *id,
                            //     args: args.take(),
                            // },
                            _ => JsValue::Null,
                        }
                    } else {
                        JsValue::Null
                    }
                } else {
                    JsValue::String(format!("this.{}", s).to_string())
                }
            }
            (JsValue::Array(v), JsValue::Int64(i)) => match v[*i as usize] {
                JsValue::Int(i) => JsValue::Int(i),
                JsValue::Null => JsValue::Null,
                _ => panic!("Not implemented {:?} {:?}", target, property_key),
            },
            _ => {
                panic!("Not implemented {:?} {:?}", target, property_key);
            }
        }
    }
    fn reflect_set(&self, target: &JsValue, property_key: &str, value: &JsValue) {
        match (target, property_key, value) {
            (JsValue::This, "_pendingEvent", JsValue::Null) => {
                // sets pending event to null but expects the object
                // to still exist so we ignore this for now
                self.shared_state().pending_event_ref = 0;
            }
            (JsValue::PendingEvent { .. }, "result", JsValue::Null) => {}
            _ => panic!(
                "Not implemented {:?} {:?} {:?}",
                target, property_key, value
            ),
        }
    }
    fn reflect_apply(
        &self,
        target: &JsValue,
        property_key: &JsValue,
        argument_list: Vec<(Option<&JsValue>, Option<i32>)>,
    ) -> JsValue {
        if let Some(r) = match target {
            JsValue::NetListener => {
                if let JsValue::FuncWrapper { id } = argument_list[0].0.unwrap() {
                    self.shared_state().net_callback_id = *id;
                }
                Some(JsValue::Undefined)
            }
            JsValue::String(t) => match t.as_ref() {
                "this._makeFuncWrapper" => {
                    // this could be a boxed FnMut value for more flexbility
                    // for now we just handle it as a one-off enum type
                    let id = argument_list[0].1.unwrap();
                    Some(JsValue::FuncWrapper { id: id })
                }
                "crypto.getRandomValues" => {
                    // String("crypto")[(
                    //     Some(Memory {
                    //         address: 201441472,
                    //         len: 10,
                    //     }),
                    //     None,
                    // )]
                    if let JsValue::Memory { address, len } = argument_list[0].0.unwrap() {
                        thread_rng()
                            .fill(self.mut_mem_slice(*address as usize, (address + len) as usize));
                    }
                    Some(JsValue::Undefined)
                }
                "Date.getTimezoneOffset" => Some(JsValue::Int(0)), // Always UTC
                "fs.write" => {
                    // String("fs write")
                    // String("fs")
                    // [
                    //   fd:       (None, Some(1)),
                    //   buffer:   (Some(Memory {
                    //                address: 201441296,
                    //                len: 16,
                    //             }), None),
                    //   offset:   (Some(Int(0)), None),
                    //   len:      (None, Some(16)),
                    //             (Some(Null), None),
                    //   callback: (Some(FuncWrapper { id: 1 }), None),
                    // ]
                    if let JsValue::Memory { address, len } = argument_list[1].0.unwrap() {
                        print!(
                            "{}",
                            str::from_utf8(self._get_bytes(*address as usize, *len as usize))
                                .unwrap()
                        );

                        if let JsValue::FuncWrapper { id } = argument_list[5].0.unwrap() {
                            let pending_event = JsValue::PendingEvent {
                                id: *id,
                                args: Some(vec![JsValue::Null, JsValue::Int(*len)]),
                            };
                            let reference = self.values().len() as i32;
                            self.values().push(pending_event);
                            self.shared_state().pending_event_ref = reference;
                        }
                        // arguments to callback might need to be pinned to global state
                        Some(JsValue::Int(*len))
                    } else {
                        panic!("Incorrect JsValue variant for js.write buffer should be JsValue::Memory")
                    }
                }
                _ => None,
            },
            _ => None,
        } {
            return r;
        } else {
            panic!(
                "Not implemented {:?} {:?} {:?}",
                target, property_key, argument_list
            );
        }
    }
    fn reflect_construct(
        &self,
        target: &JsValue,
        argument_list: Vec<(Option<&JsValue>, Option<i32>)>,
    ) -> JsValue {
        if let Some(r) = match target {
            JsValue::String(t) => match t.as_ref() {
                // Expected format:
                // String("Uint8Array")
                // [
                //     (Some(String("mem.buffer")), None),
                //     (None, Some(201441296)),
                //     (None, Some(16)),
                // ];
                "Uint8Array" => Some(JsValue::Memory {
                    address: argument_list[1].1.unwrap(),
                    len: argument_list[2].1.unwrap(),
                }),
                "Date" => Some(JsValue::String("Date".to_string())),
                "net_listener" => Some(JsValue::NetListener),
                _ => None,
            },
            _ => None,
        } {
            return r;
        } else {
            panic!("Not implemented {:?} {:?}", target, argument_list);
        }
    }
    fn get_i32(&self, sp: i32) -> i32 {
        let spu = sp as usize;
        as_i32_le(self.mem_slice(spu, spu + 8))
    }
    fn get_i64(&self, sp: i32) -> i64 {
        let spu = sp as usize;
        unsafe {
            let memory_def = &*self.definition();
            as_i64_le(
                &slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8],
            )
        }
    }
    fn get_f64(&self, sp: i32) -> f64 {
        f64::from_bits(self.get_i64(sp) as u64)
    }
    fn set_f64(&self, sp: i32, num: f64) {
        self.set_i64(sp, num.to_bits() as i64);
    }
    fn get_bytes(&self, sp: i32) -> &[u8] {
        let saddr = self.get_i32(sp) as usize;
        let ln = self.get_i32(sp + 8) as usize;
        self._get_bytes(saddr, ln)
    }
    fn _get_bytes(&self, address: usize, ln: usize) -> &[u8] {
        self.mem_slice(address, address + ln)
    }
    fn get_string(&self, sp: i32) -> &str {
        str::from_utf8(self.get_bytes(sp)).unwrap()
    }
    fn set_i64(&self, sp: i32, num: i64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&i64_as_u8_le(num));
    }
    fn set_i32(&self, sp: i32, num: i32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&i32_as_u8_le(num));
    }
    fn set_u32(&self, sp: i32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    fn set_bool(&self, addr: i32, value: bool) {
        let val = if value { 1 } else { 0 };
        self.mut_mem_slice(addr as usize, (addr + 1) as usize)
            .clone_from_slice(&[val]);
    }
    fn set_byte_array_array(&self, addr: i32, values: Vec<Vec<u8>>) {
        let mut byte_references = vec![0; values.len() * 4];
        for (i, value) in values.iter().enumerate() {
            let reference = self.store_value_bytes(value.to_vec());
            byte_references[i * 4..i * 4 + 4].clone_from_slice(&i32_as_u8_le(reference));
        }
        self.set_i32(addr, self.store_value_bytes(byte_references))
    }
    fn store_value_bytes(&self, b: Vec<u8>) -> i32 {
        let reference = self.values().len() as i32;
        self.values().push(JsValue::Bytes(b));
        reference
    }
    fn store_value(&self, addr: i32, jsv: JsValue) {
        let nan_head = 0x7FF80000;
        match jsv {
            JsValue::Int(int) => {
                if int == 0 {
                    self.set_u32(addr + 4, nan_head);
                    self.set_u32(addr, 1);
                    return;
                }
                self.set_f64(addr, int as f64);
            }
            JsValue::Null => {
                self.set_u32(addr + 4, nan_head);
                self.set_u32(addr, 2);
            }
            JsValue::True => {
                self.set_u32(addr + 4, nan_head);
                self.set_u32(addr, 3);
            }
            JsValue::False => {
                self.set_u32(addr + 4, nan_head);
                self.set_u32(addr, 4);
            }
            _ => {
                let reference = self.values().len() as i32;
                self.values().push(jsv);
                self.set_u32(addr + 4, nan_head);
                self.set_u32(addr, reference as u32);
            }
        }
    }
    fn store_string(&self, address: i32, val: String) {
        self.set_i32(address, self.store_value_bytes(val.into_bytes()));
    }
    // get_string
    fn load_string(&self, address: i32) -> String {
        let reference = self.get_i32(address);
        let b = match self.values()[reference as usize] {
            JsValue::Bytes(ref b) => b,
            _ => panic!("load_string needs bytes"),
        };
        str::from_utf8(&b).unwrap().to_string()
    }
    fn load_slice_of_values(&self, address: i32) -> Vec<(Option<&JsValue>, Option<i32>)> {
        let mut out = Vec::new();
        let array = self.get_i32(address);
        let len = self.get_i32(address + 8);
        for n in 0..len {
            out.push(self.load_value(array + n * 8))
        }
        out
    }
    fn load_value(&self, address: i32) -> (Option<&JsValue>, Option<i32>) {
        let float = self.get_f64(address);
        let intfloat = float as i32;

        if float == (intfloat) as f64 {
            //https://stackoverflow.com/questions/48500261/check-if-a-float-can-be-converted-to-integer-without-loss
            return (None, Some(intfloat));
        }
        let reference = self.get_i32(address);
        return (Some(&self.values()[reference as usize]), None);
    }
}

fn epoch_ns() -> i64 {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    since_the_epoch.as_secs() as i64 * 1_000_000_000 + since_the_epoch.subsec_nanos() as i64
}

extern "C" fn go_debug(_sp: i32) {
    println!("debug")
}

extern "C" fn go_schedule_timeout_event(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let count = fc.get_i64(sp + 8);
    let id = fc.shared_state().next_callback_timeout_id;
    fc.set_i32(sp + 16, id);
    fc.shared_state().next_callback_timeout_id += 1;
    fc.shared_state().callback_heap.push(Callback {
        time: epoch_ns() + count * 1_000_000,
        id: id,
    });
    fc.shared_state().callback_map.insert(id, true);
}
extern "C" fn go_clear_timeout_event(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    fc.shared_state().callback_map.remove(&id);
}
extern "C" fn go_syscall(_sp: i32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.store_value(sp + 24, JsValue::String(fc.get_string(sp + 8).to_string()));
}

extern "C" fn go_js_value_get(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let result = fc.reflect_get(
        &fc.load_value(sp + 8).0.unwrap(),
        &JsValue::String(fc.get_string(sp + 16).to_string()),
    );
    fc.store_value(sp + 32, result);
}
extern "C" fn go_js_value_set(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.reflect_set(
        fc.load_value(sp + 8).0.unwrap(),
        fc.get_string(sp + 16),
        fc.load_value(sp + 32).0.unwrap(),
    );
}
extern "C" fn go_js_value_index(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.store_value(
        sp + 24,
        fc.reflect_get(
            fc.load_value(sp + 8).0.unwrap(),
            &JsValue::Int64(fc.get_i64(sp + 16)),
        ),
    );
}
extern "C" fn go_js_value_set_index(_sp: i32) {
    println!("js_value_set_index")
}
extern "C" fn go_js_value_invoke(_sp: i32) {
    println!("js_value_invoke")
}
extern "C" fn go_js_value_call(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    let g = JsValue::String(fc.get_string(sp + 16).to_string());
    let m = fc.reflect_get(v.0.unwrap(), &g);
    let args = fc.load_slice_of_values(sp + 32);
    let result = fc.reflect_apply(&m, v.0.unwrap(), args);
    // TODO: catch error and error
    fc.store_value(sp + 56, result);
    fc.set_bool(sp + 64, true);
}
extern "C" fn go_js_value_new(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc
        .load_value(sp + 8)
        .0
        .expect("Reflect.construct doesn't take an int");
    let args = fc.load_slice_of_values(sp + 16);
    let result = fc.reflect_construct(v, args);
    fc.store_value(sp + 40, result);
    fc.set_bool(sp + 48, true);
}
extern "C" fn go_js_value_length(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let v = fc.load_value(sp + 8);
    let ln = match v.0 {
        Some(jsv) => match jsv {
            JsValue::Array(v) => v.len(),
            _ => 0,
        },
        None => 0,
    };
    fc.set_i64(sp + 16, ln as i64);
}
extern "C" fn go_js_value_prepare_string(_sp: i32) {
    println!("js_value_prepare_string")
}
extern "C" fn go_js_value_load_string(_sp: i32) {
    println!("js_value_load_string")
}

unsafe extern "C" fn go_wasmexit(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let exit_code = fc.get_i32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    fc.shared_state().exited = true;
}

unsafe extern "C" fn go_wasmwrite(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    print!("{}", fc.get_string(sp + 16));
}

unsafe extern "C" fn go_walltime(sp: i32, vmctx: *mut VMContext) {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    let fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, since_the_epoch.as_secs() as i64);
    fc.set_i32(sp + 8 + 8, since_the_epoch.subsec_nanos() as i32);
}

unsafe extern "C" fn go_nanotime(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.set_i64(sp + 8, epoch_ns());
}

unsafe extern "C" fn go_get_random_data(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // let random_bytes = rand::thread_rng().gen::<[u8; 32]>();
    let addr = fc.get_i32(sp + 8);
    let ln = fc.get_i32(sp + 16);
    thread_rng().fill(fc.mut_mem_slice(addr as usize, (addr + ln) as usize));
}

unsafe extern "C" fn go_load_bytes(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);

    let values = fc.values();
    let b = match values[reference as usize] {
        JsValue::Bytes(ref b) => b,
        _ => panic!("load_bytes needs bytes"),
    };
    fc.mut_mem_slice(addr as usize, (addr + ln) as usize)
        .clone_from_slice(&b);
}
unsafe extern "C" fn go_prepare_bytes(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let reference = fc.get_i32(sp + 8);
    let values = fc.values();
    let b = match values[reference as usize] {
        JsValue::Bytes(ref b) => b,
        _ => panic!("prepare_bytes needs bytes"),
    };
    fc.set_i64(sp + 16, b.len() as i64);
}

unsafe extern "C" fn go_listen_tcp(sp: i32, vmctx: *mut VMContext) {
    println!("go_listen_tcp");
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    println!("{:?}", addr);
    let listener = TcpListener::bind(&addr.parse().unwrap()).unwrap();
    let id = fc.shared_state().net_pool.add(NetTcp::Listener(listener));
    fc.set_i32(sp + 24, id as i32);
}

unsafe extern "C" fn go_accept_tcp(sp: i32, vmctx: *mut VMContext) {
    println!("go_accept_tcp");
    let fc = FuncContext::new(vmctx);
    let token = fc.get_i32(sp + 8);
    fc.shared_state()
        .poll
        .register(
            fc.shared_state()
                .net_pool
                .get_listener_ref(token as usize)
                .unwrap(),
            mio::Token(token as usize),
            mio::Ready::readable() | mio::Ready::writable(),
            mio::PollOpt::edge(),
        )
        .unwrap();
}

unsafe extern "C" fn go_read_tcp_conn(sp: i32, vmctx: *mut VMContext) {
    println!("go_read_tcp_conn");
    let fc = FuncContext::new(vmctx);
    let id = fc.get_i32(sp + 8);
    let addr = fc.get_i32(sp + 16);
    let ln = fc.get_i32(sp + 24);
    let mut stream = fc
        .shared_state()
        .net_pool
        .get_stream_ref(id as usize)
        .unwrap();
    println!("{:?}", stream);
    stream
        .read(fc.mut_mem_slice(addr as usize, (addr + ln) as usize))
        .unwrap();

    println!("{:?}", (id, addr, ln));
}

unsafe extern "C" fn go_lookup_ip(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    // TODO handle error
    let ips = resolve_host(&addr).unwrap();
    fc.set_bool(sp + 24 + 4, true);
    let mut byte_ips: Vec<Vec<u8>> = Vec::new();
    for ip in ips.iter() {
        match ip {
            IpAddr::V4(ip4) => byte_ips.push(ip4.octets().to_vec()),
            IpAddr::V6(_) => {}
        }
    }
    fc.set_byte_array_array(sp + 24, byte_ips)
}

fn resolve_host(host: &str) -> Result<Vec<IpAddr>, std::io::Error> {
    (host, 0)
        .to_socket_addrs()
        .map(|iter| iter.map(|socket_address| socket_address.ip()).collect())
}

pub fn instantiate_go() -> Result<Instance, InstantiationError> {
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);

    let functions = [
        ("debug", go_debug as *const VMFunctionBody),
        ("runtime.wasmExit", go_wasmexit as *const VMFunctionBody),
        ("runtime.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("syscall.wasmWrite", go_wasmwrite as *const VMFunctionBody),
        ("runtime.nanotime", go_nanotime as *const VMFunctionBody),
        ("runtime.walltime", go_walltime as *const VMFunctionBody),
        ("syscall.Syscall", go_syscall as *const VMFunctionBody),
        ("net.lookupHost", go_lookup_ip as *const VMFunctionBody),
        ("syscall.socket", go_debug as *const VMFunctionBody),
        (
            "runtime.scheduleTimeoutEvent",
            go_schedule_timeout_event as *const VMFunctionBody,
        ),
        (
            "runtime.clearTimeoutEvent",
            go_clear_timeout_event as *const VMFunctionBody,
        ),
        (
            "runtime.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.getRandomData",
            go_get_random_data as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.loadBytes",
            go_load_bytes as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.prepareBytes",
            go_prepare_bytes as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasabi/pkg/net.listenTcp",
            go_listen_tcp as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasabi/pkg/net.acceptTcp",
            go_accept_tcp as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasabi/pkg/net.readConn",
            go_read_tcp_conn as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.loadBytes",
            go_load_bytes as *const VMFunctionBody,
        ),
        (
            "syscall/wasm.prepareBytes",
            go_prepare_bytes as *const VMFunctionBody,
        ),
        (
            "syscall/js.stringVal",
            go_js_string_val as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueGet",
            go_js_value_get as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueSet",
            go_js_value_set as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueIndex",
            go_js_value_index as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueSetIndex",
            go_js_value_set_index as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueCall",
            go_js_value_call as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueNew",
            go_js_value_new as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueInvoke",
            go_js_value_invoke as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueLength",
            go_js_value_length as *const VMFunctionBody,
        ),
        (
            "syscall/js.valuePrepareString",
            go_js_value_prepare_string as *const VMFunctionBody,
        ),
        (
            "syscall/js.valueLoadString",
            go_js_value_load_string as *const VMFunctionBody,
        ),
    ];

    for func in functions.iter() {
        let sig = module.signatures.push(translate_signature(
            ir::Signature {
                params: vec![ir::AbiParam::new(types::I32)],
                returns: vec![],
                call_conv,
            },
            pointer_type,
        ));
        let func_index = module.functions.push(sig);
        module
            .exports
            .insert(func.0.to_owned(), Export::Function(func_index));
        finished_functions.push(func.1);
    }

    let memory = module.memory_plans.push(MemoryPlan {
        memory: Memory {
            minimum: 16384,
            maximum: None,
            shared: false,
        },
        style: MemoryStyle::Dynamic {},
        offset_guard_size: 65536,
    });
    module
        .exports
        .insert("mem".to_owned(), Export::Memory(memory));

    let imports = Imports::none();
    let data_initializers = Vec::new();
    let signatures = PrimaryMap::new();

    Instance::new(
        Rc::new(module),
        finished_functions.into_boxed_slice(),
        imports,
        &data_initializers,
        signatures.into_boxed_slice(),
        Box::new(SharedState::new()),
    )
}

fn strptr(s: &String, offset: usize, mem: &mut [u8]) -> (usize, usize) {
    let ptr = offset;
    mem[offset..offset + s.len()].copy_from_slice(s.as_bytes());
    mem[offset + s.len()] = 0u8;
    (ptr, offset + s.len() + (8 - (s.len() % 8)))
}

fn load_args_from_mem(args: Vec<String>, mem: &mut [u8]) -> (i32, i32) {
    let mut offset = 4096;
    let argc = args.len() as i32;
    let mut argv_ptrs = Vec::new();
    for arg in &args {
        let (ptr, o) = strptr(arg, offset, mem);
        offset = o;
        argv_ptrs.push(ptr)
    }

    // TODO: envvars

    let out = offset;
    for argv_ptr in &argv_ptrs {
        mem[offset..offset + 4].copy_from_slice(&u32_as_u8_le(*argv_ptr as u32));
        mem[offset + 4..offset + 4 + 4].copy_from_slice(&u32_as_u8_le(0));
        offset += 8;
    }
    (argc, out as i32)
}

fn load_args_from_definition(args: Vec<String>, definition: *mut VMMemoryDefinition) -> (i32, i32) {
    let mut mem = unsafe {
        let memory_def = &*definition;
        &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[0..16384]
    };
    load_args_from_mem(args, &mut mem)
}

pub fn run(args: Vec<String>, compiler: &mut Compiler, data: Vec<u8>) -> Result<(), String> {
    let mut c = Box::new(compiler);
    let mut namespace = Namespace::new();
    let instance = instantiate_go().expect("Instantiate go");
    let go_index = namespace.instance(Some("go"), instance);

    let instantiate_timer = SystemTime::now();
    let mut instance = instantiate(&mut *c, &data, &mut namespace).map_err(|e| e.to_string())?;
    println!(
        "Instantiation time: {:?}",
        instantiate_timer.elapsed().unwrap()
    );

    let definition = match instance.lookup("mem") {
        Some(wasmtime_runtime::Export::Memory {
            definition,
            memory: _memory,
            vmctx: _vmctx,
        }) => definition,
        Some(_) => panic!("exported item is not a linear memory",),
        None => panic!("no memory export found"),
    };

    let index = namespace.instance(Some("main"), instance);
    {
        let instance = &mut namespace.instances[go_index];
        let host_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("not a thing");
        host_state.definition = Some(definition);
    }

    let (argc, argv) = load_args_from_definition(args, definition);
    // resolver::start_event_loop();
    let mut function_name = "run";
    let mut args = vec![RuntimeValue::I32(argc), RuntimeValue::I32(argv)];
    let invoke_timer = SystemTime::now();
    loop {
        println!("{:?} {:?}", function_name, args);
        match namespace
            .invoke(&mut *c, index, function_name, &args)
            .map_err(|e| e.to_string())?
        {
            ActionOutcome::Returned { .. } => {}
            ActionOutcome::Trapped { message } => {
                return Err(format!(
                    "Trap from within function {}: {}",
                    function_name, message
                ));
            }
        }
        function_name = "resume";
        args = vec![];
        let instance = &mut namespace.instances[go_index];
        let shared_state = instance
            .host_state()
            .downcast_mut::<SharedState>()
            .expect("host state is not a SharedState");

        if shared_state.pending_event_ref != 0 {
            continue;
        }
        // TODO: poll with timeout if there is a callback that needs to run
        if let Some(callback) = shared_state.callback_heap.pop() {
            let sleep_time = time::Duration::from_nanos((callback.time - epoch_ns()) as u64);
            thread::sleep(sleep_time);
            continue;
        }
        // TODO: don't reallocate
        if !shared_state.net_pool.is_empty() {
            let mut events = mio::Events::with_capacity(1024);
            shared_state.poll.poll(&mut events, None).unwrap();
            let mut args = Vec::new();
            for event in events.iter() {
                args.push(JsValue::Int(event.token().0 as i32));
                let to_add = if let Some(ntcp) = shared_state.net_pool.get_ref(event.token().0) {
                    match ntcp {
                        NetTcp::Listener(listener) => {
                            let (mut stream, _) = listener.accept().unwrap();
                            Some(NetTcp::Stream(stream))
                        }
                        NetTcp::Stream(_) => None,
                    }
                } else {
                    None
                };
                if let Some(ntcp) = to_add {
                    match ntcp {
                        NetTcp::Listener(_) => {}
                        NetTcp::Stream(stream) => {
                            let id = shared_state.net_pool.next_id();
                            shared_state
                                .poll
                                .register(
                                    &stream,
                                    mio::Token(id),
                                    mio::Ready::readable() | mio::Ready::writable(),
                                    mio::PollOpt::edge(),
                                )
                                .unwrap();
                            shared_state.net_pool.add(NetTcp::Stream(stream));
                            args.push(JsValue::Int(id as i32));
                        }
                    }
                }
            }
            let id = shared_state.net_callback_id;
            shared_state.add_pending_event(id, Some(args));
            continue;
        }

        if shared_state.exited == false {
            shared_state.add_pending_event(0, None);
            continue;
        }

        break;
    }
    println!("Invocation time: {:?}", invoke_timer.elapsed().unwrap());

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::any::Any;

    struct TestVMContext {
        shared_state: Box<dyn Any>,
        mem: Box<dyn Any>,
    }

    struct TestContext {
        vmctx: *mut TestVMContext,
        // place the testcontext here so that it has the same
        // lifetime as the test context?
        #[allow(dead_code)]
        v: TestVMContext,
    }

    impl TestContext {
        fn new(vmctx: *mut TestVMContext, v: TestVMContext) -> Self {
            Self { vmctx: vmctx, v: v }
        }
    }
    impl ContextHelpers for TestContext {
        fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
            unsafe { &mut (&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }
        fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
            unsafe { &(&mut *self.vmctx).mem.downcast_mut::<Vec<u8>>().unwrap()[start..end] }
        }

        fn shared_state(&self) -> &mut SharedState {
            unsafe {
                (&mut *self.vmctx)
                    .shared_state
                    .downcast_mut::<SharedState>()
                    .unwrap()
            }
        }
    }

    fn test_context() -> TestContext {
        let ss = SharedState::new();
        let mem: Vec<u8> = vec![0; 100];
        let mut vmc = TestVMContext {
            shared_state: Box::new(ss),
            mem: Box::new(mem),
        };
        let tc = TestContext::new(&mut vmc as *mut TestVMContext, vmc);
        tc.values(); //prevents the mem from being freed?
        tc
    }

    #[test]
    fn test_args_and_ev() {
        let mut mem: Vec<u8> = vec![0; 10000];
        let args = vec![
            "/var/folders/nn/q8p1tdps0jlfnll5nc8ydmwc0000gn/T/go-build020729976/b001/exe/main"
                .to_string(),
        ];
        let (argc, argv) = load_args_from_mem(args, &mut mem);
        let answer: Vec<u8> = vec![
            47, 118, 97, 114, 47, 102, 111, 108, 100, 101, 114, 115, 47, 110, 110, 47, 113, 56,
            112, 49, 116, 100, 112, 115, 48, 106, 108, 102, 110, 108, 108, 53, 110, 99, 56, 121,
            100, 109, 119, 99, 48, 48, 48, 48, 103, 110, 47, 84, 47, 103, 111, 45, 98, 117, 105,
            108, 100, 48, 50, 48, 55, 50, 57, 57, 55, 54, 47, 98, 48, 48, 49, 47, 101, 120, 101,
            47, 109, 97, 105, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0,
        ];
        assert_eq!(&mem[4096..4192], &answer[..]);
        assert_eq!(argc, 1);
        assert_eq!(argv, 4184);
    }

    #[test]
    fn i32_get_and_set() {
        let tc = test_context();
        tc.set_i32(0, 2147483647);
        assert_eq!(2147483647, tc.get_i32(0));
        tc.set_i32(0, -2147483647);
        assert_eq!(-2147483647, tc.get_i32(0));
    }

    // #[test]
    // fn ms() {}
}
