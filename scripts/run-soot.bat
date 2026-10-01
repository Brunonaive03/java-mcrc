@echo off
setlocal
cd /d "%~dp0.."

if "%~1"=="" (
    echo Usage: %~nx0 ^<file_or_class^>
    exit /b 1
)

set SOOT_JAR=workspace\libs\soot-4.6.0-jar-with-dependencies.jar
if not exist "%SOOT_JAR%" (
    echo [ERROR] SOOT JAR not found: %SOOT_JAR%
    exit /b 1
)

echo === Starting Java container... ===
docker compose up -d

set CLASS_NAME=%~1
set CLASS_NAME=%CLASS_NAME:.java=%

echo.
echo === Running SOOT on %CLASS_NAME%... ===
docker compose exec -T java java -cp /workspace/libs/soot-4.6.0-jar-with-dependencies.jar soot.Main -cp /workspace/classes -pp -f J -p jb enabled:false "%CLASS_NAME%"

echo.
echo === SOOT execution complete. ===
echo Jimple output: workspace\sootOutput\
