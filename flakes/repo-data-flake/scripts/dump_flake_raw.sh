#!/bin/bash

FLAKE_NIX_FILE=$1
OUTPUT_FILE=$2

if [ -z "$FLAKE_NIX_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $0 <flake.nix_file> <output.raw-dump.txt_file>"
  exit 1
fi

echo "Dumping raw flake output for ${FLAKE_NIX_FILE}"
cat "${FLAKE_NIX_FILE}" > "${OUTPUT_FILE}" 2>&1