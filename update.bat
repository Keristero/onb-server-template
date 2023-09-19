@echo off

where rustc >nul 2>&1
if %errorlevel% == 0 (
    echo Rust is installed
    set /p installrust="Do you want to update it anyway? (y/n): "
) else (
    set /p installrust="Rust is not installed. Do you want to install it? (y/n): "
)

if /I "%installrust%"=="y" (
    curl https://win.rustup.rs -sSf -o sources/rustup-init.exe
    call "sources/rustup-init.exe"
    echo Rust has been installed or updated. Please close this window and try running the script again
    pause
    exit
)

echo Downloading the latest server source and ezlibs
git submodule update --recursive --remote

echo Compiling the latest server
cd .\sources\Scriptable-OpenNetBattle-Server

cargo build --release
cd ..\..
copy .\sources\Scriptable-OpenNetBattle-Server\target\release\net_battle_server.exe .\server\net_battle_server.exe
if %errorlevel% == 0 (
    echo net_battle_server.exe is up to date.
) 

PAUSE
