FROM maxmcd/wasm-servers:go

RUN mkdir -p /go/src/github.com/perlin-network/life/ \
    && cd /go/src/github.com/perlin-network/life \
    && git clone https://github.com/perlin-network/life.git . \
    && GO111MODULE=on go mod vendor 

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/go-wasm-lib

COPY ./cmd/runtime ../runtime
RUN cd ../runtime && go install

COPY ./cmd/go-wasm-lib .
COPY ./pkg/gowasm ../../pkg/gowasm

RUN GOOS=js GOARCH=wasm go build -o go-wasm-lib.wasm 

CMD runtime ./go-wasm-lib.wasm
