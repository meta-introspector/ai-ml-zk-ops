#!/usr/bin/env bash

# Navigate to the project root (current directory)
cd "$(dirname "$0")" || exit 1

echo "Attempting to run 'cargo build' from $(pwd)"

cargo build
EXIT_CODE=$?

printf "\n'cargo build' exited with code: %s\n" "$EXIT_CODE"

if [ $EXIT_CODE -ne 0 ]; then
    echo "Error: cargo build failed. This might be the issue we are observing."
else
    echo "Success: cargo build completed without error."
fi
