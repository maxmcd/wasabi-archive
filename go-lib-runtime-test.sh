set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

cd wasabi
cargo +nightly build --release

cd ../programs/go-lib-only
GOOS=js GOARCH=wasm go1.12beta1 build -o go-lib-only.wasm

cd ../..
RUST_BACKTRACE=full ./wasabi/target/release/wasabi \
    ./programs/go-lib-only/go-lib-only.wasm
