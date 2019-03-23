set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

GOOS=js GOARCH=wasm go1.12beta1 build -o go-https.wasm

cd ../../wasabi
cargo +nightly build --release

cd ..
RUST_BACKTRACE=full ./wasabi/target/release/wasabi \
    ./programs/go-https/go-https.wasm
