set -Eeuxo pipefail

unset RUST_LOG

cd "$(dirname ${BASH_SOURCE[0]})"

cd ../../edgestack/superstellar/
GOOS=js GOARCH=wasm go1.12beta1 build -o superstellar.wasm .

cd ../../maxmcd/wasabi

cd ./wasabi
cargo +nightly build --release

cd ..
RUST_BACKTRACE=full ./wasabi/target/release/wasabi \
    ../../edgestack/superstellar/superstellar.wasm
