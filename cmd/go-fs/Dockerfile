FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-fs

COPY ./go-fs .
COPY ./runtime ../runtime
RUN cd ../runtime && go install

RUN GOOS=js GOARCH=wasm go build -o go-fs.wasm 

CMD runtime ./go-fs.wasm
