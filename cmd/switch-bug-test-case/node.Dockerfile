FROM golang:latest as golang


WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/switch-bug-test-case

RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_11.x | bash -\
    && apt-get install -y --no-install-recommends \
    nodejs=11* \
    libssl-dev=1.1.0* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./switch-bug-test-case/ .

CMD GOOS=js GOARCH=wasm go run -exec="$(go env GOROOT)/misc/wasm/go_js_wasm_exec" .
