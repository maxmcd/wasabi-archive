# Wasm Servers

The goal of this project is to experiment with a WebAssembly runtime that will run Go programs. The Go program should have full networking capability, be fast, and strongly sandboxed.

Cranelift and Wasmtime are used for the WebAssembly runtime. 

## Resources

- https://cloudabi.org/write/rust/
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

