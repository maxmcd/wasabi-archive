set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

export AWS_PROFILE=max

eval $(docker-machine env wasabi-run)
docker-compose up -d
