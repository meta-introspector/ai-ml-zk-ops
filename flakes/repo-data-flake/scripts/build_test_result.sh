#!/bin/bash

FLAKE_NIX_FILE=$1
OUTPUT_JSON_FILE=$2

SCRIPT_NAME=$(basename "$0")

if [ -z "$FLAKE_NIX_FILE" ] || [ -z "$OUTPUT_JSON_FILE" ]; then
  echo "Usage: $SCRIPT_NAME <flake.nix_file> <output.test-result.json_file>"
  exit 1
fi

echo "Building test result for ${FLAKE_NIX_FILE}"

NIX_COMMAND="nix build -f \"${FLAKE_NIX_FILE}\" --json"
NIX_OUTPUT=$(eval "$NIX_COMMAND" 2>&1)
NIX_EXIT_CODE=$?

echo "${NIX_OUTPUT}" > "${OUTPUT_JSON_FILE}"

if [ ${NIX_EXIT_CODE} -ne 0 ]; then
  echo "ERROR in ${SCRIPT_NAME} for ${FLAKE_NIX_FILE}:"
  echo "${NIX_OUTPUT}"
  echo "To reproduce, run:"
  echo "${NIX_COMMAND}"
  exit ${NIX_EXIT_CODE}
fi
