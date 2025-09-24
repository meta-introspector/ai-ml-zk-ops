#!/usr/bin/env bash
#
# Filename: nix_test_runner.sh
# Description: This script is designed to be called by a Nix derivation.
#              It executes the project's main test script (`test.sh`)
#              and redirects its output to a specified log file.
#              This adheres to the rule that Nix commands should only call scripts
#              for complex expressions.
#
# Usage (within a Nix derivation):
#   ./nix_test_runner.sh <path_to_test_script> <path_to_output_log>
#
# Arguments:
#   $1: Absolute path to the `test.sh` script.
#   $2: Absolute path to the output log file (e.g., $out/test_output.log).
#
# Output:
#   - All output from `test.sh` is redirected to the specified log file.
#
# Rules Adhered To:
#   - Nix commands only call scripts (this script is the target).
#   - All complex expressions are in scripts (the logic for running test.sh and logging).
#
# Nix Flakes Context:
#   This script acts as an intermediary between the Nix derivation and the
#   project's test suite. It ensures that the test execution environment is
#   properly set up by Nix, and that the test results are captured in a
#   structured manner within the Nix store.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Check for required arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <path_to_test_script> <path_to_output_log>"
  exit 1
fi

TEST_SCRIPT="$1"
OUTPUT_LOG="$2"

# Create the directory for the output log if it doesn't exist
mkdir -p "$(dirname "$OUTPUT_LOG")"

echo "--- Nix Test Runner Started ---"
echo "Executing test script: $TEST_SCRIPT"
echo "Logging output to: $OUTPUT_LOG"

# Execute the test script and redirect its output
"$TEST_SCRIPT" > "$OUTPUT_LOG" 2>&1

echo "--- Nix Test Runner Completed ---"
