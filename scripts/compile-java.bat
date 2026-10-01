@echo off
setlocal
cd /d "%~dp0.."

if "%~1"=="" (
    echo Usage: %~nx0 ^<file.java^>
    exit /b 1
)

echo === Starting Java container... ===
docker compose up -d

echo.
echo === Compiling %~1... ===
docker compose exec -T java javac -d /workspace/classes "/workspace/%~1"

echo === Compilation complete. ===
