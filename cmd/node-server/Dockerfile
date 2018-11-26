FROM golang:latest as golang

WORKDIR /go/src/github.com/maxmcd/wasm-servers/

RUN go get github.com/gorilla/mux
COPY ./pkg/ ./pkg/
COPY ./cmd/node-server/main.go ./cmd/node-server/main.go
RUN GOOS=js GOARCH=wasm go build -o node-server.wasm ./cmd/node-server

FROM mhart/alpine-node:11
WORKDIR /opt/
COPY ./cmd/node-server .
RUN npm ci
COPY --from=golang /go/src/github.com/maxmcd/wasm-servers/node-server.wasm .
