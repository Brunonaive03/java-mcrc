@echo off
setlocal
cd /d "%~dp0.."

echo === Starting Java container... ===
docker compose up -d

rem Sync Maven settings.xml into the container if available on host
if exist "%USERPROFILE%\.m2\settings.xml" (
    docker compose exec -T java mkdir -p /root/.m2
    docker compose cp "%USERPROFILE%\.m2\settings.xml" java:/root/.m2/settings.xml
) else if exist ".\settings.xml" (
    docker compose exec -T java mkdir -p /root/.m2
    docker compose cp ".\settings.xml" java:/root/.m2/settings.xml
) else if exist ".\conflict-static-analysis\settings.xml" (
    docker compose exec -T java mkdir -p /root/.m2
    docker compose cp ".\conflict-static-analysis\settings.xml" java:/root/.m2/settings.xml
) else if exist ".\settings.xml.example" (
    docker compose exec -T java mkdir -p /root/.m2
    docker compose cp ".\settings.xml.example" java:/root/.m2/settings.xml
)

echo.

if "%~1"=="" (
    echo === Running conflict-static-analysis tests... ===
    docker compose exec -w /conflict-static-analysis -T java mvn test-compile org.apache.maven.plugins:maven-surefire-plugin:3.2.5:test
) else (
    echo === Running conflict-static-analysis with arguments: %* ===
    docker compose exec -w /conflict-static-analysis -T java mvn %*
)

echo.
echo === Execution complete. ===
