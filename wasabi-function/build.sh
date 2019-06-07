set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"


cargo +nightly build --target wasm32-unknown-wasi --release
cd ..
ls -lah target/wasm32-unknown-wasi/release/fnmut.wasm
wasm-strip target/wasm32-unknown-wasi/release/fnmut.wasm
ls -lah target/wasm32-unknown-wasi/release/fnmut.wasm
wasm2wat target/wasm32-unknown-wasi/release/fnmut.wasm > fnmut.wat
