set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

cargo +nightly build --release

RUST_BACKTRACE=all ./target/release/wasabi ./test.wat
