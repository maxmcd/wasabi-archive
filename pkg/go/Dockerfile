FROM golang:1.11

WORKDIR /go/src/github.com/maxmcd/wasm-servers/pkg/go-wasm

RUN go get github.com/go-interpreter/wagon

COPY . .

RUN find . -type f -exec cp -v --parents {} /usr/local/go/src \;

