@echo off
setlocal
cd /d "%~dp0.."

if "%~1"=="" (
    echo Usage: %~nx0 ^<file.java or class^>
    exit /b 1
)

echo === Starting Java container... ===
docker compose up -d

echo.
echo === Running %~1... ===
set ARG=%~1
if "%ARG:~-5%"==".java" (
    docker compose exec -T java java "/workspace/%~1"
) else (
    docker compose exec -T java java -cp /workspace/classes "%~1"
)
