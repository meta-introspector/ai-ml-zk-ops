#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/run-test.sh <test_definition_file>

TEST_DEFINITION_FILE="$1"

# shellcheck disable=SC1090
source "$TEST_DEFINITION_FILE"

LOG_FILE="test_lattice_output.log" # This log file is in the root of the flake

log() {
  echo "$@" | tee -a "$LOG_FILE"
}

# Function to escape special characters for grep -E
escape_for_grep() {
  # shellcheck disable=SC2001
  echo "$1" | sed 's/[][()\.^*+?|{}]/\\&/g'
}

# Check if the test has already passed in the log file
escaped_test_name=$(escape_for_grep "$TEST_NAME")
if grep -q -E "^--- Running Test: ${escaped_test_name} ---\nResult: PASSED$" "$LOG_FILE" 2>/dev/null; then
  log "--- Skipping Test: $TEST_NAME (Already PASSED) ---"
  log ""
  exit 0
fi

log "--- Running Test: $TEST_NAME ---"
log "Command: $COMMAND"

if eval "$COMMAND" &>> "$LOG_FILE"; then
  log "Result: PASSED"
else
  log "Result: FAILED"
  log "Error details (from log file):"
  tail -n 10 "$LOG_FILE"
  exit 1
fi
log ""
