FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-print

COPY ./go-print .
COPY ./runtime ../runtime
RUN cd ../runtime && go install

RUN GOOS=js GOARCH=wasm go build -o go-print.wasm 

CMD runtime ./go-print.wasm
