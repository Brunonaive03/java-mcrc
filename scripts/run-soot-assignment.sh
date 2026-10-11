#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

echo "=== Starting Java container... ==="
docker compose up -d

echo

echo "=== Running SootAssignmentAnalysis tests... ==="
docker compose exec -w /SootAssignmentAnalysis -T java mvn test-compile org.apache.maven.plugins:maven-surefire-plugin:3.2.5:test

echo
echo "=== Execution complete. ==="
