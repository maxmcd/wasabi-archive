FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-fs

COPY . .

CMD GOOS=js GOARCH=wasm go build -o go-fs.wasm && mv go-fs.wasm ../../shared

