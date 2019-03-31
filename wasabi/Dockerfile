FROM rust

WORKDIR /opt/

RUN apt-get update \
    && apt-get install -y \
    cmake \
    clang \
    `# noop`

RUN rustup install nightly

RUN mkdir -p /opt/target/

ENV CARGO_TARGET_DIR=/opt/target

WORKDIR /opt/wasabi-io

COPY ./wasabi-io/Cargo.toml Cargo.toml
RUN mkdir src && touch src/main.rs && cargo +nightly build --release || true


WORKDIR /opt/wasabi
COPY ./wasabi/Cargo.toml Cargo.toml
COPY ./wasabi/Cargo.lock Cargo.lock
RUN mkdir src && touch src/main.rs && cargo +nightly build --release || true

COPY ./wasabi-io/ /opt/wasabi-io
COPY ./wasabi/ .
RUN cargo +nightly build --release


FROM debian:stretch-slim

COPY --from=0 /opt/target/release/wasabi /bin/wasabi
