#!/bin/bash

FLAKE_NIX_FILE=$1
OUTPUT_REPORT_FILE=$2

SCRIPT_NAME=$(basename "$0")

if [ -z "$FLAKE_NIX_FILE" ] || [ -z "$OUTPUT_REPORT_FILE" ]; then
  echo "Usage: $SCRIPT_NAME <flake.nix_file> <output.2gram-report.txt_file>"
  exit 1
fi

echo "Generating 2-gram report for ${FLAKE_NIX_FILE}"

# Create a temporary directory for the flake.nix content and 2-gram output
TEMP_DIR=$(mktemp -d)
TEMP_FLAKE_FILE="${TEMP_DIR}/flake.nix"
TEMP_2GRAM_OUTPUT="${TEMP_DIR}/2gram_output.txt"

# Copy the content of the flake.nix file to the temporary file
cat "${FLAKE_NIX_FILE}" > "${TEMP_FLAKE_FILE}"

# Run generate-2-gram.sh with the temporary directory as input and the temp dir as output
# Redirect all output (stdout and stderr) to a temporary file
/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/ai-ml-zk-ops/flakes/repo-data-flake/scripts/generate-2-gram.sh "${TEMP_DIR}" "${TEMP_DIR}" > "${TEMP_2GRAM_OUTPUT}" 2>&1

# Capture the exit code of generate-2-gram.sh
GENERATE_2GRAM_EXIT_CODE=$?

# Copy the content of the temporary output file to the desired report file
cat "${TEMP_2GRAM_OUTPUT}" > "${OUTPUT_REPORT_FILE}"

# Clean up the temporary directory
rm -rf "${TEMP_DIR}"

# If generate-2-gram.sh failed, print an error message and exit with its code
if [ ${GENERATE_2GRAM_EXIT_CODE} -ne 0 ]; then
  echo "ERROR in ${SCRIPT_NAME} for ${FLAKE_NIX_FILE}:"
  cat "${OUTPUT_REPORT_FILE}" # Print the captured error output
  exit ${GENERATE_2GRAM_EXIT_CODE}
fi