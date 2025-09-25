#!/bin/bash

FLAKE_NIX_FILE=$1
OUTPUT_FILE=$2

SCRIPT_NAME=$(basename "$0")

if [ -z "$FLAKE_NIX_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $SCRIPT_NAME <flake.nix_file> <output.lint-result.txt_file>"
  exit 1
fi

echo "Linting flake for ${FLAKE_NIX_FILE}"

# Run the nix command and capture its output and exit code
NIX_OUTPUT=$(nix flake check "${FLAKE_NIX_FILE}" 2>&1)
NIX_EXIT_CODE=$?

# Write the output to the file
echo "${NIX_OUTPUT}" > "${OUTPUT_FILE}"

# If the nix command failed, print an error message and exit with its code
if [ ${NIX_EXIT_CODE} -ne 0 ]; then
  echo "ERROR in ${SCRIPT_NAME} for ${FLAKE_NIX_FILE}:"
  echo "${NIX_OUTPUT}"
  exit ${NIX_EXIT_CODE}
fi
