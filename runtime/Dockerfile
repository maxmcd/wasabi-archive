FROM rust

WORKDIR /opt/runtime/

RUN apt-get update \
    && apt-get install -y \
    cmake \
    clang \
    `# noop`

RUN rustup install nightly

# Cache the bulk of the dependencies
RUN mkdir src && touch src/main.rs \
&& echo \
'[package] \n\
name = "runtime" \n\
version = "0.1.0" \n\
authors = ["maxmcd <m@xmcd.me>"] \n\
[dependencies] \n\
cranelift-codegen = "0.26.0" \n\
cranelift-native = "0.26.0" \n\
cranelift-entity = "0.26.0" \n\
cranelift-wasm = "0.26.0" \n\
wasmtime-environ = { git = "https://github.com/CraneStation/wasmtime" } \n\
wasmtime-runtime = { git = "https://github.com/CraneStation/wasmtime" } \n\
wasmtime-execute = { git = "https://github.com/CraneStation/wasmtime" } \n\
wasmtime-obj = { git = "https://github.com/CraneStation/wasmtime" } \n\
wasmtime-wast = { git = "https://github.com/CraneStation/wasmtime" } \n\
' > Cargo.toml \
&& cat Cargo.toml && cargo +nightly build --release || true

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml
RUN cargo +nightly build --release || true && rm src/*.rs


