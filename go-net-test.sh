set -o xtrace
set -o pipefail
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

cd wasabi
cargo +nightly build --release

cd ../programs/go-net
GOOS=js GOARCH=wasm go1.12beta1 build -o go-net.wasm

cd ../..
RUST_BACKTRACE=full ./wasabi/target/release/wasabi \
    ./programs/go-net/go-net.wasm
