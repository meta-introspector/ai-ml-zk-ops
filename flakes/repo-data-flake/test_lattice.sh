#!/usr/bin/env bash

set -e # Exit immediately if a command exits with a non-zero status.

log_file="test_lattice_output.log"
rm -f "$log_file" || true # Remove if exists, ignore error if not

log() {
  echo "$@" | tee -a "$log_file"
}

run_test() {
  local test_name="$1"
  local command="$2"
  log "--- Running Test: $test_name ---"
  log "Command: $command"
  if eval "$command" &>> "$log_file"; then
    log "Result: PASSED"
  else
    log "Result: FAILED"
    log "Error details (from log file):"
    # Print the last few lines of the log file to show the error
    tail -n 10 "$log_file" | tee -a /dev/stderr
    exit 1 # Stop after the first failure
  fi
  log ""
}

# --- Test cases ---

# 1. base-flake
run_test "base-flake: Build and run hello" "nix build ./flakes/base-flake#hello && ./result/bin/hello"

# 2. add-repo-data-lib
run_test "add-repo-data-lib: Build hello (inherited)" "nix build ./flakes/add-repo-data-lib#hello && ./result/bin/hello"
run_test "add-repo-data-lib: Evaluate lib.repoData" "nix eval --raw ./flakes/add-repo-data-lib#lib.repoData"
run_test "add-repo-data-lib: Evaluate lib.repoAttrs" "nix eval --raw ./flakes/add-repo-data-lib#lib.repoAttrs"

# 3. add-2gram-script (Need to create this flake first)
# 4. add-repo2gram-package (Need to create this flake first)

log "--- All tests completed ---"
