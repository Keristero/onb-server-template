@echo off
cd sources

:menu
cls
echo 1. Start the server
echo 2. View server logs (ctrl+c to exit)
echo 3. Update and start the server
echo x. Stop the server
echo q. exit

set /p choice=Select an option: 

if "%choice%"=="1" (
    echo Starting the server
    docker-compose up -d
) else if "%choice%"=="2" (
    echo Showing server logs:
    docker-compose logs -f --tail=500
) else if "%choice%"=="3" (
    echo pulling latest code
    git submodule update --recursive --remote
    echo Rebuilding the server
    docker-compose up --build -d
) else if "%choice%"=="x" (
    echo Stopping the server...
    docker-compose down
) else (
    echo Bye!
    exit /b
)
PAUSE
goto menu