#!/usr/bin/env bash

# Test script to run testit.sh and report its outcome.

TESTIT_SCRIPT="./testit.sh"

# Check if testit.sh exists
if [ ! -f "$TESTIT_SCRIPT" ]; then
    echo "Error: testit.sh not found at $TESTIT_SCRIPT"
    exit 1
fi

# Make testit.sh executable if it's not already
if [ ! -x "$TESTIT_SCRIPT" ]; then
    echo "Making testit.sh executable..."
    if ! chmod +x "$TESTIT_SCRIPT"; then
        echo "Error: Failed to make testit.sh executable."
        exit 1
    fi
fi

echo "Running testit.sh..."

# Run testit.sh and capture output and exit code
OUTPUT=$("$TESTIT_SCRIPT" 2>&1)
EXIT_CODE=$?

echo "--- Output of testit.sh ---"
echo "$OUTPUT"
echo "---------------------------"

if [ $EXIT_CODE -eq 0 ]; then
    echo "SUCCESS: testit.sh exited with code 0."
else
    echo "FAILURE: testit.sh exited with code $EXIT_CODE."
fi

exit $EXIT_CODE
