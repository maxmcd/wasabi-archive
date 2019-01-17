set -o xtrace
set -o pipefail
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

cd runtime
cargo +nightly build --release
RUNTIME=$(pwd)
cd $(go1.12beta1 env GOROOT)/src
GOOS=js GOARCH=wasm RUST_BACKTRACE=full \
    go1.12beta1 test -v ./... --exec=$RUNTIME/target/release/runtime

