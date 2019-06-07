set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"


cargo +nightly build --target wasm32-unknown-wasi --release
ls -lah target/wasm32-unknown-wasi/release/hello.wasm
wasm-strip target/wasm32-unknown-wasi/release/hello.wasm
ls -lah target/wasm32-unknown-wasi/release/hello.wasm
wasm2wat target/wasm32-unknown-wasi/release/hello.wasm > hello.wat
