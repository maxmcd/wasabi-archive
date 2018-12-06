FROM maxmcd/wasm-servers:go

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/switch-bug-test-case

COPY ./life-runtime ../life-runtime
RUN cd ../../cmd/life-runtime && go install


COPY ./switch-bug-test-case/ .

ENV GOOS=js 
ENV GOARCH=wasm
CMD go run -exec="runtime" main.go

