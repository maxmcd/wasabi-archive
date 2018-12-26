FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-print

COPY . .

CMD GOOS=js GOARCH=wasm go build -o go-print.wasm && mv go-print.wasm ../../shared
