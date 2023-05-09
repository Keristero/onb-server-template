FROM rust:latest as builder

WORKDIR /usr/src/myapp
COPY . .
RUN cargo install --path ./Scriptable-OpenNetBattle-Server

FROM debian:bullseye-slim
RUN apt-get update && \
    apt-get install libssl-dev
COPY --from=builder /usr/local/cargo/bin/net_battle_server /net_battle_server
# this next line copies the server to your volume and runs it
EXPOSE 8765
CMD cp ./net_battle_server ./server/net_battle_server && cd ./server && ./net_battle_server --resend-budget 196608