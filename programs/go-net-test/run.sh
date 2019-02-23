set -Eeuxo pipefail

unset RUST_LOG

cd "$(dirname ${BASH_SOURCE[0]})"

pkill wasabi || true

go run main.go bash -c "../go-net/run.sh"

