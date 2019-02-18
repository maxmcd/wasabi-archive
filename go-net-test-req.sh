set -Eeuxo pipefail

unset RUST_LOG

cd "$(dirname ${BASH_SOURCE[0]})"

pkill wasabi || true

cd programs/go-net-test
go run main.go bash -c "../../go-net-test.sh"

