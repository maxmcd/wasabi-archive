
# WASM Servers

WASM is a sandboxed low-level runtime with lots of interest. WASM currently runs in-browser, but there are several server-side runtimes available. Let's create a runtime to allow for mature web services to be built using WASM. Go/C/C++/Rust/Typescript web services can all be compiled to wasm and run with very small memory footprints.

## Notes


Rust might need a custom bindgen, likely a fork of the existing wasm bindgen. Possible name: wasm-server-bindgen
Unclear if that bindgen needs to be a fork of the existing bindgen or if this is enough of a replacement to merit a completely new project. Eg: is there shared ffi? is there complex stuff happening in wasm-bindgen i'm not considering

Go needs a fork of existing Go. Likely fork at tag 1.11 and start mutating the existing _js build files. Replace roundtrip with something else (likely just need to figure out how to pass the struct back to the wasm runtime). Then mock out necessary syscalls. Would be cool to see if we could get pions/webrtc working. 

Typescript, look into this, likely a secondary concern.

Routing: How! Work through UDP/TCP use cases. Balance: load-balancing, UDP, static ips, port-remapping, IPV6, routing to multiple locations

KV: shared KV store, look at candidates. Cassandra, Foundation

Infra: how, where, what is needed? SSL? Why is no one else supporting TCP/UDP raw? Look into those silly javascript workers made by the guys that made a js/css/html terminal. See what features are nice. 

Life: good wasm runtime candidate. Fast (benchmark against nodejs/v8), and good resource constraints. Let's us write in Go. Open questions:
- Threads? When?
- What is performance like when calling between wasm and the server
- What WASM tests are failing? Are they relevant?

Think about web editor and build. Think about allowing one to run something like this in the web with certain function calls mocked out.


## Resources

- https://github.com/AssemblyScript/assemblyscript
- https://github.com/golang/go/issues/27462
- https://rpython.readthedocs.io/en/latest/faq.html#could-we-use-llvm
- https://www.reddit.com/r/rust/comments/8y3fei/how_do_modules_like_stdfs_and_stdnet_work_with/
- https://github.com/golang/go/wiki/WebAssembly#executing-webassembly-with-node-js
- https://www.nomadproject.io/docs/drivers/exec.html
- https://github.com/WebAssembly/design/issues/304
- https://github.com/golang/go/issues/27766
- https://github.com/Xe/go/commit/37bc30ec064a32a630cdad325f83020c1f5be976
