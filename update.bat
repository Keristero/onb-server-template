@echo off

where rustc >nul 2>&1
if %errorlevel% == 0 (
    echo Rust is installed
    set /p installrust="Do you want to try update it anyway? (y/n)? "
) else (
    set /p installrust="y"
    echo Rust is not installed, press any key to download and install
    PAUSE
)

if /I "%installrust%"=="y" (
    curl https://win.rustup.rs -sSf -o sources/rustup-init.exe
    call "sources/rustup-init.exe"
    refreshenv
)

echo Downloading latest server source and ezlibs
git submodule update --recursive --remote

echo Compiling latest server
cd .\sources\Scriptable-OpenNetBattle-Server

cargo build --release
cd ..\..
copy .\sources\Scriptable-OpenNetBattle-Server\target\release\net_battle_server.exe .\server\net_battle_server.exe
if %errorlevel% == 0 (
    echo net_battle_server.exe is up to date.
)