# Wasabi

A webassembly runtime designed for multitenancy

Wasabi is a webassembly runtime built using [Cranelift](https://github.com/cranestation/cranelift) and [Wasmtime](https://github.com/cranestation/wasmtime).

Currently Wasabi runs Go programs compiled to webassembly and provides some access to underlying system resources. Go wasm programs rely on the browser context and [this execution file](https://github.com/golang/go/blob/release-branch.go1.12/misc/wasm/wasm_exec.js). Wasabi mocks out (almost) all of the functionality in this file with a few caveats:

 - There is no filesystem access at the moment (other than writing to stdout)
 - No Go standard library networking functionality is supported. Limited networking is provided by [a separate library](https://godoc.org/github.com/maxmcd/wasabi)
 - A handful of wasm_exec.js functions are not supported and it is generally not suggested to use the syscall/js library

Wasabi is very rough around the edges. Don't expect it to work very well and please open an issue if you experience any bugs. 

## Go Example

There is a simple go program [here](./programs/go-net-example/main.go) that runs an http server and makes 1000 requests to itself before exiting. Here are some of the relevant bits from that file:

```go

// import the wasabi library
import "github.com/maxmcd/wasabi"

// This is how you would replace http.Get. It's required to pass the Wasabi
// transport to the http client
func httpGet(url string) (*http.Response, error) {
    client := http.Client{Transport: &wasabi.RoundTripper{}}
    req, err := http.NewRequest("GET", url, nil)
    if err != nil {
        return nil, err
    }
    return client.Do(req)
}
// Wasabi provides a replacement for http.ListenAndServe
log.Fatal(wasabi.ListenAndServe("127.0.0.1:8080", handler))
```

Compile this program into a wasm binary. **Only Go 1.12 is supported** 

```bash
GOOS=js GOARCH=wasm go build -o go-net-example.wasm
```

cd into ./wasabi and run the following to build and run wasabi

```bash
cargo +nightly run --release -- ../programs/go-net-example/go-net-example.wasm
```

The server should then spin up and you should see the logging output from the requests.

## Sandboxing

One of the goals of Wasabi is to provide a safe runtime to run untrusted code. The current implementation is presumed to be memory safe and is mostly safe otherwise due to a lack of implemented functionality. eg: there's no filesystem access. Most TCP networking functionality is implemented so there are no current restrictions on outbound tcp requests. Over time more functionality will be added to provide limited system resource access. cloudabi could be a worthwhile candidate for sandboxing, but ulimit and runtime-level constraints might be enough. 

## Roadmap

- Go 1.12 fully supported with all expected networking functionality
- Compilation performance improvements
- Rust and Typescript support
- Cloudabi exported functions
- And much more... hopefully :) 
