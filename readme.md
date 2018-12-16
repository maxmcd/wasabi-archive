
# WASM Servers

WASM is a sandboxed low-level runtime with lots of interest. WASM currently runs in-browser, but there are several server-side runtimes available. Let's create a runtime to allow for mature web services to be built using WASM. Go/C/C++/Rust/Typescript web services can all be compiled to wasm and run with very small memory footprints.

## Notes/Ramblings

Rust might need a custom bindgen, likely a fork of the existing wasm bindgen. Possible name: wasm-server-bindgen
Unclear if that bindgen needs to be a fork of the existing bindgen or if this is enough of a replacement to merit a completely new project. Eg: is there shared ffi? is there complex stuff happening in wasm-bindgen i'm not considering

Go needs a fork of existing Go. Likely fork at tag 1.11 and start mutating the existing _js build files. Replace roundtrip with something else. Then mock out necessary syscalls.

Networked wasm servers deployed to edge networks mean some cool things. You have a runtime available to you at a close gographic proximity whenever you want at no cost. This enables web experiences where you need some level of system access in the browser. Web proxies are a good example, traffic proxy at an edge location, self-hosted, one-click to deploy. 

Something like a docker controller, or a minimal web shell that controls computing resources is also possible. Connect to your docker-machine image, it dynamically connects to docker machines. 

Applications are also super portable and easy to save/resume. Could automatically detect no tcp connections and sleep until the next tcp connection. Allow for services that are only on when used with minimal startup delays. ms not s. 

### Networking, runtime design

The runtime should be installed on a server. The runtime has an http api and can be given jobs/services to run. The runtime handles service availability, configuration and shutdown. Ideally, the runtime also proxies incoming network requests to every service. Since the network stack is owned, it would be nice if services could broadcast on the same port, similar to an nginx setup matching on port and hostname. ie: we have 6 services broadcasting on port 80, one of them udp. Packets come in and we match on host header or ip addr (if the service is asigned an ip).

In this form the runtime could be installed and integrated into something like nomad as a driver. Nomad can pass env vars, map ports, control resources, run shell scripts(?). All of these would need to be supported. 

The runtime could also be installed locally. Allowing opt-in sandboxing of external programs. A docker-registry esque service could be use to push and install programs. The runtime would be very minimal and portable. "Download ripgrep and just give it read access to directories it is searching". 

## Resources

- Candidate Typescript compiler <br /> https://github.com/AssemblyScript/assemblyscript
- Some llvm limitations for pypy, possibly re: python on wasm <br /> https://rpython.readthedocs.io/en/latest/faq.html#could-we-use-llvm
- Rust syscall limitations <br /> https://www.reddit.com/r/rust/comments/8y3fei/how_do_modules_like_stdfs_and_stdnet_work_with/
- NodeJS webassembly runtime <br /> https://github.com/golang/go/wiki/WebAssembly#executing-webassembly-with-node-js
- WASM application security considerations <br /> https://github.com/WebAssembly/design/issues/304
- Discussion around the future of the go/wasm runtime context <br /> https://github.com/golang/go/issues/27766
- Potentially relevant bug with new Go compiler target <br /> https://github.com/Xe/go/commit/37bc30ec064a32a630cdad325f83020c1f5be976
- Primary rust commit for limited syscall support in wasm builds <br />https://github.com/rust-lang/rust/commit/36695a37c52a0e6cc582247a506ab0b3c764b48f#diff-9882b092ae8f77ccfa6907e8212fc8e6
- Mozilla summary of WASM state of the world <br /> https://hacks.mozilla.org/2018/10/webassemblys-post-mvp-future/
- WASM internals and design pdf<br /> https://takenobu-hs.github.io/downloads/WebAssembly_illustrated.pdf
- Emscripten filesytem sycall interface <br /> https://kripken.github.io/emscripten-site/docs/api_reference/Filesystem-API.html
- Mozilla WASM compiler. (look out for soon-to-be-open-sourced fastly runtime) <br /> https://github.com/CraneStation/cranelift
- Fastly wasm talk <br /> https://www.youtube.com/watch?v=FkM1L8-qcjU


# Infra

- User busybox and minimal linux along with firecracker. Do this to get things running until a true sandboxed vm can be created. 
- Get Rust running and set up a nomad cluster and some services
- Figure out cpu/memory allocations
- Set up build and deploy system
- Figure out request routing
- Create a emscripten target for Go

