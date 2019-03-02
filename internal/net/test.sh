set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

cd ../../wasabi
cargo +nightly build --release

cd ../internal/net
RUST_BACKTRACE=full GOOS=js GOARCH=wasm \
    go1.12beta1 test -exec="../../wasabi/target/release/wasabi" -v
