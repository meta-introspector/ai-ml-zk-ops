#!/usr/bin/env bash

# Input directory
INPUT_DIR="$1"
OUTPUT_DIR="$2" # Changed to OUTPUT_DIR

# Check if input directory is provided
if [ -z "$INPUT_DIR" ]; then
  echo "Usage: $0 <input_directory> <output_directory>"
  exit 1
fi

# Create the output directory if it doesn't exist (though runCommand usually provides it)
mkdir -p "$OUTPUT_DIR"

# Find all text files, read their content, tokenize, and generate 2-grams
find "$INPUT_DIR" -type f -print0 | xargs -0 cat | \
  tr -s '[:space:]' '\n' | \
  grep -v '^\s*$' | \
  awk '
    BEGIN { prev = ""; }
    {
      if (prev != "") {
        print prev " " $0;
      }
      prev = $0;
    }
  ' | \
  jq -R -s 'split("\n") | map(select(length > 0))' > "$OUTPUT_DIR/2gram.json" # Write to a file inside the output directory