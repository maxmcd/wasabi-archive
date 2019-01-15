use cranelift_codegen::ir::types;
use cranelift_codegen::{ir, isa};
use cranelift_entity::PrimaryMap;
use cranelift_wasm::DefinedFuncIndex;
use cranelift_wasm::Memory;
use rand::{thread_rng, Rng};
use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::net::{IpAddr, ToSocketAddrs};
use std::process::exit;
use std::rc::Rc;
use std::slice;
use std::sync::mpsc;
use std::time::{SystemTime, UNIX_EPOCH};
use std::{str, thread};
use target_lexicon::HOST;
use wasmtime_environ::MemoryPlan;
use wasmtime_environ::{translate_signature, Export, MemoryStyle, Module};
use wasmtime_jit::InstantiationError;
use wasmtime_runtime::{Imports, Instance, VMContext, VMFunctionBody, VMMemoryDefinition};

struct FuncContext {
    vmctx: *mut VMContext,
}

#[derive(Debug)]
enum JsValue {
    Bytes(Vec<u8>),
    String(String),
    Memory { address: i32, len: i32 },
    FuncWrapper { id: i32 },
    Int(i32),
    Int64(i64),
    Undefined,
    True,
    False,
    Array(Vec<JsValue>),
    NaN,
    Null,
    Global,
    Mem,
    This,
}

#[derive(Debug)]
struct PendingEvent {
    id: i32,
    len: i32,
    null: bool,
}

#[derive(Debug, Eq)]
pub struct Callback {
    pub time: i64,
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
pub struct SharedState {
    pub definition: Option<*mut VMMemoryDefinition>,
    pub result_sender: Option<mpsc::Sender<String>>,
    values: Vec<JsValue>,
    envvars: HashMap<String, String>,
    pending_event: PendingEvent,
    pub should_resume: bool,
    next_callback_timeout_id: i32,
    pub callback_heap: BinaryHeap<Callback>,
    pub callback_map: HashMap<i32, bool>,
}
impl SharedState {
    fn new() -> Self {
        Self {
            values: vec![
                JsValue::NaN,    // NaN,
                JsValue::Int(0), // 0,
                JsValue::Null,   // null,
                JsValue::True,   // true,
                JsValue::False,  // false,
                JsValue::Global, // global,
                JsValue::Mem,    // this._inst.exports.mem,
                JsValue::This,   // this,
            ],
            envvars: HashMap::new(),
            result_sender: None,
            definition: None,
            pending_event: PendingEvent {
                id: 0,
                len: 0,
                null: false,
            },
            should_resume: false,
            next_callback_timeout_id: 1,
            callback_heap: BinaryHeap::new(),
            callback_map: HashMap::new(),
        }
    }
}

impl FuncContext {
    fn new(vmctx: *mut VMContext) -> Self {
        Self { vmctx: vmctx }
    }

    fn shared_state(&self) -> &mut SharedState {
        unsafe {
            (&mut *self.vmctx)
                .host_state()
                .downcast_mut::<SharedState>()
                .unwrap()
        }
    }

    unsafe fn definition(&self) -> *mut VMMemoryDefinition {
        self.shared_state().definition.unwrap()
    }
    fn result_sender(&self) -> &mpsc::Sender<String> {
        self.shared_state()
            .result_sender
            .as_ref()
            .expect("I should have a sender")
    }
    fn values(&self) -> &mut Vec<JsValue> {
        &mut self.shared_state().values
    }
    fn envvars(&self) -> &mut HashMap<String, String> {
        &mut self.shared_state().envvars
    }
    fn get_i32(&self, sp: i32) -> i32 {
        let spu = sp as usize;
        unsafe {
            let memory_def = &*self.definition();
            as_i32_le(
                &slice::from_raw_parts(memory_def.base, memory_def.current_length)[spu..spu + 8],
            )
        }
    }
    fn reflect_get(&self, target: &JsValue, property_key: &JsValue) -> JsValue {
        println!("reflect_get {:?} {:?}", target, property_key);
        match (target, property_key) {
            (JsValue::Global, JsValue::String(s)) => JsValue::String(s.to_string()),
            (JsValue::String(t), JsValue::String(pk)) => match (t.as_ref(), pk.as_ref()) {
                ("fs", "constants") => JsValue::String("fs.constants".to_string()),
                ("fs", "write") => JsValue::String("fs.write".to_string()),
                ("fs.constants", _) => {
                    JsValue::Int(-1)
                    // wasm_exec.js:42
                    // constants: {
                    //     O_WRONLY: -1, O_RDWR: -1, O_CREAT: -1,
                    //     O_TRUNC: -1, O_APPEND: -1, O_EXCL: -1 },
                    // unused
                }
                ("this._pendingEvent", "id") => JsValue::Int(self.shared_state().pending_event.id),
                ("this._pendingEvent", "this") => JsValue::This,
                ("this._pendingEvent", "args") => JsValue::Array(vec![
                    JsValue::Null,
                    JsValue::Int(self.shared_state().pending_event.len),
                ]),
                _ => {
                    panic!("Not implemented {:?} {:?}", target, property_key);
                }
            },
            (JsValue::Mem, JsValue::String(_pk)) => {
                // mem.buffer
                JsValue::String("mem.buffer".to_string())
            }
            (JsValue::This, JsValue::String(s)) => {
                if s == "_pendingEvent" && self.shared_state().pending_event.null {
                    JsValue::Null
                } else {
                    JsValue::String(format!("this.{}", s).to_string())
                }
            }
            (JsValue::Array(v), JsValue::Int64(i)) => {
                if *i == 1 {
                    self.shared_state().pending_event.null = true;
                }
                match v[*i as usize] {
                    JsValue::Int(i) => JsValue::Int(i),
                    JsValue::Undefined => JsValue::Undefined,
                    JsValue::Null => JsValue::Null,
                    _ => panic!("Not implemented {:?} {:?}", target, property_key),
                }
            }
            _ => {
                panic!("Not implemented {:?} {:?}", target, property_key);
            }
        }
    }
    fn reflect_set(&self, target: &JsValue, property_key: &str, value: &JsValue) {
        match (target, property_key, value) {
            (JsValue::This, "_pendingEvent", JsValue::Null) => {
                self.shared_state().should_resume = false;
                // self.shared_state().next_callback_timeout_id = 0;
            }
            (JsValue::String(_), "result", JsValue::Null) => {}
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
            JsValue::String(t) => match t.as_ref() {
                "this._makeFuncWrapper" => {
                    // this could be a boxed FnMut value for more flexbility
                    // for now we just handle it as a one-off enum type
                    let id = argument_list[0].1.unwrap();
                    Some(JsValue::FuncWrapper { id: id })
                }
                "fs.write" => {
                    // String("fs write")
                    // String("fs")
                    // [
                    //   fd:      (None, Some(1)),
                    //   buffer:  (Some(Memory {
                    //               address: 201441296,
                    //               len: 16,
                    //            }), None),
                    //   offset:  (Some(Int(0)), None),
                    //   len:     (None, Some(16)),
                    //            (Some(Null), None),
                    //            (Some(FuncWrapper { id: 1 }), None),
                    // ]
                    if let JsValue::Memory { address, len } = argument_list[1].0.unwrap() {
                        print!(
                            "{}",
                            str::from_utf8(self._get_bytes(*address as usize, *len as usize))
                                .unwrap()
                        );
                        self.shared_state().pending_event.len = *len;
                        self.shared_state().pending_event.null = false;
                        self.shared_state().should_resume = true;
                        if let JsValue::FuncWrapper { id } = argument_list[5].0.unwrap() {
                            self.shared_state().pending_event.id = *id
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
                _ => None,
            },
            _ => None,
        } {
            return r;
        } else {
            panic!("Not implemented {:?} {:?}", target, argument_list);
        }
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
        let memory_def = unsafe { &*self.definition() };
        unsafe {
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)
                [address..address + ln]
        }
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
    fn mut_mem_slice(&self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
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
            JsValue::Undefined => {
                self.set_f64(addr, 0 as f64);
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

fn as_i32_le(array: &[u8]) -> i32 {
    ((array[0] as i32) << 0)
        | ((array[1] as i32) << 8)
        | ((array[2] as i32) << 16)
        | ((array[3] as i32) << 24)
}

fn as_i64_le(array: &[u8]) -> i64 {
    ((array[0] as i64) << 0)
        | ((array[1] as i64) << 8)
        | ((array[2] as i64) << 16)
        | ((array[3] as i64) << 24)
        | ((array[4] as i64) << 32)
        | ((array[5] as i64) << 40)
        | ((array[6] as i64) << 48)
        | ((array[7] as i64) << 56)
}

fn i64_as_u8_le(x: i64) -> [u8; 8] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
        ((x >> 32) & 0xff) as u8,
        ((x >> 40) & 0xff) as u8,
        ((x >> 48) & 0xff) as u8,
        ((x >> 56) & 0xff) as u8,
    ]
}

fn i32_as_u8_le(x: i32) -> [u8; 4] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
    ]
}

fn u32_as_u8_le(x: u32) -> [u8; 4] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
    ]
}

fn ms_epoch() -> i64 {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    since_the_epoch.as_secs() as i64 * 1000 + since_the_epoch.subsec_nanos() as i64 / 1_000_000
}

#[allow(clippy::print_stdout)]
unsafe extern "C" fn env_println(start: usize, len: usize, vmctx: *mut VMContext) {
    let definition = FuncContext::new(vmctx).definition();
    let memory_def = &*definition;
    let message =
        &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..start + len];
    println!("{:?}", str::from_utf8(&message).unwrap());
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
        time: ms_epoch() + count,
        id: id,
    });
    fc.shared_state().callback_map.insert(id, true);
    println!("schedule callback at time {:?} {:?}", count, id);
}
extern "C" fn go_clear_timeout_event(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    println!("go_clear_timeout_event");
    let id = fc.get_i32(sp + 8);
    fc.shared_state().callback_map.remove(&id);
}
extern "C" fn go_syscall(_sp: i32) {
    println!("go_syscall")
}

extern "C" fn go_js_string_val(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    fc.store_value(sp + 24, JsValue::String(fc.load_string(sp + 8)));
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

    // if object == "crypto" && method == "getRandomValues" {
    //     let (address, len) = match fc.values()[fc.get_i32(array + 0 * 8) as usize] {
    //         JsValue::Memory { address, len } => (address, len),
    //         _ => panic!("getRandomValues should write bytes"),
    //     };
    //     thread_rng().fill(fc.mut_mem_slice(address as usize, (address + len) as usize));
    // }
    // // Uint32Array is actually "global", but we don't mock the instantiated _values
    // // should likely populate the array to make this clearer
    // if object == "Uint32Array" && method == "_makeFuncWrapper" {
    //     println!("makefunc call {}", fc.get_f64(array + 0 * 8));
    //     fc.shared_state().should_resume = true;
    //     fc.shared_state().pending_event_id = fc.get_f64(array + 0 * 8) as i32;
    // }
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
    // let len = fc.get_i32(sp + 16 + 8);
    // let name = fc.load_string(sp + 8);
    // println!("js_value_new {} {} {}", name, array, len);
    // if name == "Uint8Array" {
    //     let address = fc.get_f64(array + 1 * 8) as i32;
    //     let len = fc.get_f64(array + 2 * 8) as i32;
    //     fc.store_value(sp + 40, JsValue::Memory { address, len });
    // } else {
    //     fc.store_string(sp + 40, "value_new_value".to_string());
    // }

    // just always lie and say it worked
}
extern "C" fn go_js_value_length(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    // args, length
    fc.set_i64(sp + 16, 2);
}
extern "C" fn go_js_value_prepare_string(_sp: i32) {
    println!("js_value_prepare_string")
}
extern "C" fn go_js_value_load_string(_sp: i32) {
    println!("js_value_load_string")
}

extern "C" fn go_set_env(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let key = fc.get_string(sp + 8);
    let value = fc.get_string(sp + 24);
    let envvars = fc.envvars();
    envvars.insert(key.to_owned(), value.to_owned());
}

extern "C" fn go_get_env(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let key = fc.get_string(sp + 8);
    let envvars = fc.envvars();
    match envvars.get(key) {
        Some(value) => {
            fc.set_bool(sp + 24, true);
            fc.store_string(sp + 28, value.to_string());
        }
        None => {
            fc.set_bool(sp + 24, false);
        }
    }
}

unsafe extern "C" fn go_wasmexit(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let exit_code = fc.get_i32(sp + 8);
    if exit_code != 0 {
        println!("Wasm exited with a non-zero exit code: {}", exit_code);
    }
    exit(exit_code);
}
unsafe extern "C" fn go_start_request(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    println!("{:?}", fc.get_string(sp + 8));
    let memory_def = &*fc.definition();
    println!(
        "{:?}",
        &slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)
            [(sp as usize)..(sp + 100) as usize]
    );
    let sender = fc.result_sender();
    sender.send(fc.get_string(sp + 24 + 8).to_string()).unwrap();
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
    fc.set_i64(sp + 8, ms_epoch());
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

unsafe extern "C" fn go_lookup_ip(sp: i32, vmctx: *mut VMContext) {
    let fc = FuncContext::new(vmctx);
    let addr = fc.get_string(sp + 8);
    // TODO handle error
    let ips = resolve_host(&addr).unwrap();
    fc.set_bool(sp + 24 + 4, true);
    let mut byte_ips: Vec<Vec<u8>> = Vec::new();
    println!("{:?}", ips);
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

pub fn start_event_loop() -> mpsc::Sender<String> {
    let (send, recv) = mpsc::channel();

    thread::spawn(move || loop {
        match recv.try_recv() {
            Ok(pay) => {
                println!("got payload{:?}", pay);
                // Client::new().get(&pay).send();
            }
            Err(err) => match err {
                std::sync::mpsc::TryRecvError::Empty => {}
                std::sync::mpsc::TryRecvError::Disconnected => {
                    return;
                }
            },
        };
    });

    send
}

/// Return an instance implementing the "spectest" interface used in the
/// spec testsuite.
pub fn instantiate_env() -> Result<Instance, InstantiationError> {
    let call_conv = isa::CallConv::triple_default(&HOST);
    let pointer_type = types::Type::triple_pointer_type(&HOST);
    let mut module = Module::new();
    let mut finished_functions: PrimaryMap<DefinedFuncIndex, *const VMFunctionBody> =
        PrimaryMap::new();

    let sig = module.signatures.push(translate_signature(
        ir::Signature {
            params: vec![ir::AbiParam::new(types::I32), ir::AbiParam::new(types::I32)],
            returns: vec![],
            call_conv,
        },
        pointer_type,
    ));
    let func = module.functions.push(sig);
    module
        .exports
        .insert("println".to_owned(), Export::Function(func));
    finished_functions.push(env_println as *const VMFunctionBody);

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
        .insert("memory".to_owned(), Export::Memory(memory));

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
            "github.com/maxmcd/wasm-servers/gowasm.setenv",
            go_set_env as *const VMFunctionBody,
        ),
        (
            "github.com/maxmcd/wasm-servers/gowasm.getenv",
            go_get_env as *const VMFunctionBody,
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
            "github.com/maxmcd/wasm-servers/gowasm/http.startRequest",
            go_start_request as *const VMFunctionBody,
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
