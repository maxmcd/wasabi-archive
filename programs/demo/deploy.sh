set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

export AWS_PROFILE=max

GOOS=js GOARCH=wasm go1.12beta1 build -o demo.wasm

eval $(docker-machine env wasabi-run)
docker pull maxmcd/wasabi
docker-compose build app
docker-compose up -d
