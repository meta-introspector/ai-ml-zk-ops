#!/bin/bash

SH_FILE=$1
OUTPUT_FILE=$2

if [ -z "$SH_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $0 <shell_script_file> <output_file>"
  exit 1
fi

echo "Running shellcheck for ${SH_FILE}"
shellcheck "${SH_FILE}" > "${OUTPUT_FILE}" 2>&1
