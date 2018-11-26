FROM golang:latest as golang

WORKDIR /go/src/github.com/maxmcd/wasm-servers/

COPY ./cmd/go-server/main.go ./cmd/go-server/main.go
RUN GOOS=js GOARCH=wasm go build -o go-server.wasm ./cmd/go-server

COPY ./cmd/runtime/main.go ./cmd/runtime/main.go
WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/runtime

RUN go run main.go ../../go-server.wasm
