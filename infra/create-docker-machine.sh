set -Eeuxo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

export AWS_PROFILE=max

docker-machine create wasabi-run --driver amazonec2 \
    --amazonec2-instance-type=t3.medium\
    --amazonec2-open-port=8080 \
    --amazonec2-region=us-east-1 \
    --amazonec2-root-size=15 \
    --amazonec2-vpc-id=vpc-05b0f29cb877ff323 \
    --amazonec2-ssh-keypath=/Users/maxm/.ssh/id_rsa
