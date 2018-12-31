set -e
cd "$(dirname ${BASH_SOURCE[0]})"

cd runtime 
cargo +nightly build --release

cd ../programs/go-lib-only
GOOS=js GOARCH=wasm go build -o go-lib-only.wasm

cd ../..
RUST_BACKTRACE=1 ./runtime/target/release/runtime --invoke=run \
    ./programs/go-lib-only/go-lib-only.wasm
