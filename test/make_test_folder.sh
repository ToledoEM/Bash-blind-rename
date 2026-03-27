#!/usr/bin/env bash
# Creates test_example/ folder structure matching the README.md example

set -euo pipefail

TARGET="test_example"

if [ -d "$TARGET" ]; then
    echo "Removing existing $TARGET/ folder..."
    rm -rf "$TARGET"
fi

mkdir -p "$TARGET/subfolder"

for i in $(seq 1 10); do
    touch "$TARGET/foo_${i}.txt"
done

for i in $(seq 1 10); do
    touch "$TARGET/subfolder/bar_${i}.txt"
done

echo "Created $TARGET/ with foo_1.txt … foo_10.txt"
echo "Created $TARGET/subfolder/ with bar_1.txt … bar_10.txt"
