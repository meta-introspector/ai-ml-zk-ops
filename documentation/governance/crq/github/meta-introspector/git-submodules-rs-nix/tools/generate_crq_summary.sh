#!/usr/bin/env bash

# This script generates a summary table of CRQs grouped by their suggested next step.

# Assuming crq_table_generator executable is in target/release/
# Adjust path if necessary based on your build
CRQ_TABLE_GENERATOR_PATH="./target/release/crq_table_generator"

if [ ! -x "$CRQ_TABLE_GENERATOR_PATH" ]; then
  echo "Error: crq_table_generator executable not found at $CRQ_TABLE_GENERATOR_PATH."
  echo "Please ensure the crq_table_generator project is built (cargo build --release)."
  exit 1
fi

echo "Generating CRQ summary report..."
"$CRQ_TABLE_GENERATOR_PATH"