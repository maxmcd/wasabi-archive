FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/pkg/gowasm

COPY ./cmd/runtime ../../cmd/runtime
RUN cd ../../cmd/runtime && go install

COPY ./pkg/gowasm .
ENV GOOS=js 
ENV GOARCH=wasm
# CMD go test -exec="runtime" -v
CMD go test -v -exec="runtime"

