#!/bin/bash

# Set server settings
port=8765

# Check if the server is already compiled or provided
if [ -f "server/net_battle_server" ]; then
    echo "Server already compiled!"
else
    echo "Server is not compiled, installing"
    ./update.sh
fi

cd server
./net_battle_server --port $port --resend-budget 196608
echo "The server encountered an error and closed."
read -p "Press Enter to continue..."