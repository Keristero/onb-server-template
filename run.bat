@echo off
REM set server settings
set /A port=8765


REM check to see if the server is already compiled or provided
IF EXIST "server\net_battle_server.exe" (
    echo Server already compiled!
) else (
    echo Server is not compiled, installing
    call update.bat
)

cd server
net_battle_server.exe --port %port% --resend-budget 196608
echo The server encounted an error and closed.
PAUSE