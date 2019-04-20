set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

eval $(docker-machine env circleci-docker-machine)

docker-compose build wasabi
docker-compose push wasabi
