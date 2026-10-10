#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

echo "=== Starting Java container... ==="
docker compose up -d

echo
echo "=== Running SOOT on directory... ==="

docker compose exec -w /workspace/classes -T java java \
    -cp ../libs/soot-4.6.0-jar-with-dependencies.jar \
    soot.Main \
    -process-dir . \
    -d /workspace/sootOutput \
    -f J \
    -p jb enabled:false

echo
echo "=== SOOT execution complete. ==="
echo "Jimple output: workspace/sootOutput/"
