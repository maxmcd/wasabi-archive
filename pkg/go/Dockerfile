FROM golang:1.11

WORKDIR /go/src/github.com/maxmcd/wasm-servers/pkg/go-wasm

RUN mkdir -p /go/src/github.com/perlin-network/life/ \
    && cd /go/src/github.com/perlin-network/life \
    && git clone https://github.com/perlin-network/life.git . \
    && GO111MODULE=on go mod vendor 

COPY . .

RUN find . -type f -exec cp -v --parents {} /usr/local/go/src \;

