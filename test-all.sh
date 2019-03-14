set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

export GO111MODULE=off

go1.12beta1 test
./programs/go-test-wasabi.sh
./programs/go-lib-only/run.sh
cd wasabi && RUST_BACKTRACE=full cargo +nightly test --release -- --nocapture
