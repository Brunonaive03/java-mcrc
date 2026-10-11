#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

echo "=== Starting Java container... ==="
docker compose up -d

# Load .env if present
if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

# Sync Maven settings.xml into the container if available on host
docker compose exec -T java mkdir -p /root/.m2
if [ -f "$HOME/.m2/settings.xml" ]; then
    docker compose cp "$HOME/.m2/settings.xml" java:/root/.m2/settings.xml
elif [ -f "./settings.xml" ]; then
    docker compose cp "./settings.xml" java:/root/.m2/settings.xml
elif [ -f "./conflict-static-analysis/settings.xml" ]; then
    docker compose cp "./conflict-static-analysis/settings.xml" java:/root/.m2/settings.xml
elif [ -f "./settings.xml.example" ]; then
    docker compose cp "./settings.xml.example" java:/root/.m2/settings.xml
fi

# Inform user if settings.xml is missing (GitHub Packages requires authentication)
if ! docker compose exec -T java test -f /root/.m2/settings.xml 2>/dev/null; then
    echo "Notice: No settings.xml found in /root/.m2/."
    echo "If dependency resolution fails with 401 Unauthorized, see conflict-static-analysis/README.md"
    echo "and settings.xml.example to configure your GitHub token."
fi

echo

if [ $# -eq 0 ]; then
    echo "=== Running conflict-static-analysis tests... ==="
    docker compose exec -w /conflict-static-analysis -T java mvn test-compile org.apache.maven.plugins:maven-surefire-plugin:3.2.5:test
else
    echo "=== Running conflict-static-analysis with arguments: $@ ==="
    docker compose exec -w /conflict-static-analysis -T java mvn "$@"
fi

echo
echo "=== Execution complete. ==="
