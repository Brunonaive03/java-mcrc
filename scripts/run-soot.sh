#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

FILE="$1"
if [[ -z "$FILE" ]]; then
    echo "Usage: $0 <file.java or class>"
    exit 1
fi

SOOT_JAR="workspace/libs/soot-4.6.0-jar-with-dependencies.jar"
if [[ ! -f "$SOOT_JAR" ]]; then
    echo "[ERROR] SOOT JAR not found: $SOOT_JAR"
    exit 1
fi

echo "=== Starting Java container... ==="
docker compose up -d

CLASS_NAME="${FILE%.java}"

echo
echo "=== Running SOOT on $CLASS_NAME... ==="

docker compose exec -T java java \
    -cp /workspace/libs/soot-4.6.0-jar-with-dependencies.jar \
    soot.Main \
    -cp /workspace/classes \
    -pp \
    -f J \
    -p jb enabled:false \
    "$CLASS_NAME"

echo
echo "=== SOOT execution complete. ==="
echo "Jimple output: workspace/sootOutput/"
