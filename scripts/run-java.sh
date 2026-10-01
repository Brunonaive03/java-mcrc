#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

FILE="$1"
if [[ -z "$FILE" ]]; then
    echo "Usage: $0 <file.java or class>"
    exit 1
fi

echo "=== Starting Java container... ==="
docker compose up -d

echo
echo "=== Running $FILE... ==="
if [[ "$FILE" == *.java ]]; then
    docker compose exec -T java java "/workspace/$FILE"
else
    docker compose exec -T java java -cp /workspace/classes "$FILE"
fi
