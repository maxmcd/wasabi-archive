pub fn as_i32_le(array: &[u8]) -> i32 {
    ((array[0] as i32) << 0)
        | ((array[1] as i32) << 8)
        | ((array[2] as i32) << 16)
        | ((array[3] as i32) << 24)
}

pub fn as_i64_le(array: &[u8]) -> i64 {
    ((array[0] as i64) << 0)
        | ((array[1] as i64) << 8)
        | ((array[2] as i64) << 16)
        | ((array[3] as i64) << 24)
        | ((array[4] as i64) << 32)
        | ((array[5] as i64) << 40)
        | ((array[6] as i64) << 48)
        | ((array[7] as i64) << 56)
}

pub fn i64_as_u8_le(x: i64) -> [u8; 8] {
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

pub fn i32_as_u8_le(x: i32) -> [u8; 4] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
    ]
}

pub fn u32_as_u8_le(x: u32) -> [u8; 4] {
    [
        (x & 0xff) as u8,
        ((x >> 8) & 0xff) as u8,
        ((x >> 16) & 0xff) as u8,
        ((x >> 24) & 0xff) as u8,
    ]
}
