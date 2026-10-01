#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

FILE="$1"
if [[ -z "$FILE" ]]; then
    echo "Usage: $0 <file.java>"
    exit 1
fi

echo "=== Starting Java container... ==="
docker compose up -d

echo
echo "=== Compiling $FILE... ==="
docker compose exec -T java javac -d /workspace/classes "/workspace/$FILE"

echo "=== Compilation complete. ==="
