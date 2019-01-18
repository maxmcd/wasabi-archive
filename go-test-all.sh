set -o xtrace
set -o pipefail
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

cd wasabi
cargo +nightly build --release
WASABI=$(pwd)
cd $(go1.12beta1 env GOROOT)/src
GOOS=js GOARCH=wasm RUST_BACKTRACE=full \
    go1.12beta1 test -v ./... --exec=$WASABI/target/release/wasabi

