FROM golang:1.11

WORKDIR /go/src/github.com/maxmcd/wasm-servers/pkg/go-wasm

COPY . .

RUN find . -type f -exec cp -v --parents {} /usr/local/go/src \;

