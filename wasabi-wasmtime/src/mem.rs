use std::{slice, str};
use wasabi::bytes::{as_i32_le, as_i64_le, i32_as_u8_le, i64_as_u8_le, u32_as_u8_le};
use wasmtime_runtime::VMMemoryDefinition;

#[derive(Debug)]
pub struct Mem {
    pub definition: Option<*mut VMMemoryDefinition>,
}

impl Mem {
    pub fn new() -> Self {
        Self { definition: None }
    }
}

pub trait Actions {
    fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8];
    fn mem_slice(&self, start: usize, end: usize) -> &[u8];
    fn get_i32(&self, sp: i32) -> i32 {
        let spu = sp as usize;
        as_i32_le(self.mem_slice(spu, spu + 8))
    }
    fn set_i32(&mut self, sp: i32, num: i32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&i32_as_u8_le(num));
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
    fn get_f64(&self, sp: i32) -> f64 {
        f64::from_bits(self.get_i64(sp) as u64)
    }
    fn set_i64(&mut self, sp: i32, num: i64) {
        self.mut_mem_slice(sp as usize, (sp + 8) as usize)
            .clone_from_slice(&i64_as_u8_le(num));
    }
    fn set_u32(&mut self, sp: i32, num: u32) {
        self.mut_mem_slice(sp as usize, (sp + 4) as usize)
            .clone_from_slice(&u32_as_u8_le(num));
    }
    fn set_bool(&mut self, addr: i32, value: bool) {
        let val = if value { 1 } else { 0 };
        self.mut_mem_slice(addr as usize, (addr + 1) as usize)
            .clone_from_slice(&[val]);
    }
    fn set_f64(&mut self, sp: i32, num: f64) {
        self.set_i64(sp, num.to_bits() as i64);
    }
    fn get_i64(&self, sp: i32) -> i64 {
        let spu = sp as usize;
        as_i64_le(self.mem_slice(spu, spu + 8))
    }
}

impl Actions for Mem {
    fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8] {
        unsafe {
            let memory_def = &*self.definition.unwrap();
            &mut slice::from_raw_parts_mut(memory_def.base, memory_def.current_length)[start..end]
        }
    }
    fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
        unsafe {
            let memory_def = &*self.definition.unwrap();
            &slice::from_raw_parts(memory_def.base, memory_def.current_length)[start..end]
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    struct TestMem {
        mem: Vec<u8>,
    }

    impl TestMem {
        fn new() -> Self {
            Self { mem: vec![0; 1000] }
        }
    }
    impl Actions for TestMem {
        fn mut_mem_slice(&mut self, start: usize, end: usize) -> &mut [u8] {
            &mut self.mem[start..end]
        }
        fn mem_slice(&self, start: usize, end: usize) -> &[u8] {
            &self.mem[start..end]
        }
    }

    #[test]
    fn get_set_i32() {
        let mut mem = TestMem::new();
        mem.set_i32(100, 3456);
        assert_eq!(mem.get_i32(100), 3456);
    }

    #[test]
    fn get_set_i64() {
        let mut mem = TestMem::new();
        mem.set_i64(100, 3456);
        assert_eq!(mem.get_i64(100), 3456);
    }

}
