#!/bin/bash

if command -v rustc >/dev/null 2>&1; then
    echo "Rust is installed"
    read -p "Do you want to update it anyway? (y/n): " installrust
else
    read -p "Rust is not installed. Do you want to install it? (y/n): " installrust
fi

if [[ "$installrust" == "y" || "$installrust" == "Y" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo "Rust has been installed or updated. Please close this window and try running the script again"
    read -p "Press Enter to continue..."
    exit
fi

echo "Downloading the latest server source and ezlibs"
git submodule update --recursive --remote

echo "Compiling the latest server"
cd ./sources/Scriptable-OpenNetBattle-Server || exit
cargo build --release
cd ../../
cp ./sources/Scriptable-OpenNetBattle-Server/target/release/net_battle_server ./server/net_battle_server
if [ $? -eq 0 ]; then
    echo "net_battle_server is up to date."
fi

read -p "Press Enter to continue..."
