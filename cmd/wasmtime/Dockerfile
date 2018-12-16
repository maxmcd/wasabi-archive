FROM rust

RUN rustup install nightly
RUN apt-get update \
    && apt-get install -y \
    cmake \
    clang \
    `# noop`

WORKDIR /opt/wasmtime/
