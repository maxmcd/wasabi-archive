use std::time::{SystemTime, UNIX_EPOCH};
pub fn epoch_ns() -> i64 {
    let start = SystemTime::now();
    let since_the_epoch = start.duration_since(UNIX_EPOCH).unwrap();
    since_the_epoch.as_secs() as i64 * 1_000_000_000 + i64::from(since_the_epoch.subsec_nanos())
}
