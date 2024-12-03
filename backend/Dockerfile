FROM rust:1.82-bookworm AS plan
WORKDIR /tmp
RUN cargo install cargo-chef
COPY Cargo.toml Cargo.lock ./
COPY src src
RUN cargo chef prepare --recipe-path recipe.json


FROM rust:1.82-bookworm AS cache
WORKDIR /tmp
RUN cargo install cargo-chef
COPY --from=plan /tmp/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json


FROM rust:1.82-bookworm AS builder
WORKDIR /tmp
COPY Cargo.toml Cargo.lock ./
COPY src src
COPY --from=cache /tmp/target target
COPY --from=cache /usr/local/cargo /usr/local/cargo
RUN cargo build --release


FROM debian:bookworm
WORKDIR /usr/bin
COPY --from=builder /tmp/target/release/kmontocam-backend .
COPY src/translations.json src/translations.json
EXPOSE 3000
CMD ["/usr/bin/kmontocam-backend"]
