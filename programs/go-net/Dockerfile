FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-net

COPY . .

CMD GOOS=js GOARCH=wasm go build -o go-net.wasm && mv go-net.wasm ../../shared

