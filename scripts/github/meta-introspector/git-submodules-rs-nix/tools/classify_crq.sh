#!/usr/bin/env bash

# This script classifies a CRQ file and suggests the next step.

CRQ_FILE="$1"

if [ -z "$CRQ_FILE" ]; then
  echo "Usage: $0 <path_to_crq_file>"
  exit 1
fi

if [ ! -f "$CRQ_FILE" ]; then
  echo "Error: CRQ file not found: $CRQ_FILE"
  exit 1
fi

# Assuming crq-parser executable is in target/debug/ or target/release/
# Adjust path if necessary based on your build
CRQ_PARSER_PATH="./target/debug/crq-parser"

if [ ! -x "$CRQ_PARSER_PATH" ]; then
  echo "Error: crq-parser executable not found at $CRQ_PARSER_PATH."
  echo "Please ensure the crq-parser project is built (cargo build -p crq-parser)."
  exit 1
fi

echo "Classifying CRQ: $CRQ_FILE"
"$CRQ_PARSER_PATH" --file "$CRQ_FILE"