set -o xtrace
set -o pipefail
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

cd runtime
cargo +nightly build --release

cd ../programs/go-lib-only
GOOS=js GOARCH=wasm go1.12beta1 build -o go-lib-only.wasm

cd ../..
RUST_BACKTRACE=full ./runtime/target/release/runtime --invoke=run \
    ./programs/go-lib-only/go-lib-only.wasm
