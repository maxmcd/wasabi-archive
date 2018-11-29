FROM golang:1.11

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add wasm32-unknown-unknown \
    && cargo install --git https://github.com/alexcrichton/wasm-gc

RUN mkdir -p /go/src/github.com/perlin-network/life/ \
    && cd /go/src/github.com/perlin-network/life \
    && git clone https://github.com/perlin-network/life.git . \
    && GO111MODULE=on go mod vendor 

WORKDIR /go/src/github.com/maxmcd/wasm-servers/cmd/rust-basic/
COPY ./rust-basic/Cargo.toml .
COPY ./rust-basic/Cargo.lock .
RUN mkdir src && touch src/lib.rs && cargo build --release


COPY ./runtime ../runtime

RUN cd ../runtime && go install

COPY ./rust-basic/src ./src

RUN cargo build --target wasm32-unknown-unknown --release \
    && wasm-gc target/wasm32-unknown-unknown/release/rust_basic.wasm

CMD runtime target/wasm32-unknown-unknown/release/rust_basic.wasm
