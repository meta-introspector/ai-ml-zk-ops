#!/usr/bin/env bash
#
# Filename: run_workflow.sh
# Description: This script orchestrates the full development workflow:
#              1. Commits all current changes to Git, using a commit message
#                 read from `context/commit_message.txt`.
#              2. Executes the Nix flake's test check, which in turn runs
#                 `test.sh` (which calls `build.sh` and logs its output).
#              This ensures that tests are always run on committed code
#              within a reproducible Nix environment.
#
# Usage:
#   ./run_workflow.sh
#
# Arguments:
#   None. The commit message is read from `context/commit_message.txt`.
#
# Output:
#   - Git commit of current changes.
#   - Output from the Nix flake's test check, including logs from `test.sh`.
#
# Rules Adhered To:
#   - All complex commands are wrapped.
#   - Univalent idea: Takes no parameters and "does what I mean" (DWIM).
#   - Context on the stack: Paths are resolved relative to the script's location,
#     and commit message is sourced from the `context/` directory.
#
# Nix Flakes Context:
#   This script embodies the principle of running tests on committed code
#   within a hermetic Nix environment. By integrating the commit step and
#   then invoking the Nix flake check, it ensures that the entire process
#   is reproducible and that the test results accurately reflect the state
#   of the version-controlled codebase.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define the path to the commit script and commit message file
COMMIT_SCRIPT="${SCRIPT_DIR}/commit.sh"
COMMIT_MESSAGE_FILE="${SCRIPT_DIR}/context/commit_message.txt"

echo "--- Starting Full Workflow ---"

# Step 1: Commit current changes
echo "1. Committing current changes."

# Read commit message from file
if [ ! -f "$COMMIT_MESSAGE_FILE" ]; then
  echo "Error: Commit message file not found at $COMMIT_MESSAGE_FILE"
  exit 1
fi
COMMIT_MESSAGE=$(cat "$COMMIT_MESSAGE_FILE")

# Check if the commit message is empty
if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Error: Commit message file is empty. Please provide a commit message in $COMMIT_MESSAGE_FILE"
  exit 1
fi

"$COMMIT_SCRIPT" "$COMMIT_MESSAGE"

# Step 2: Run the Nix flake's test check
echo "2. Running Nix flake tests (via checks.runTests)..."
export NIX_CONFIG="experimental-features = nix-command flakes"

# Get the current system
CURRENT_SYSTEM=$(nix eval --raw --impure --expr 'builtins.currentSystem')

echo "   Executing: nix build .#checks.${CURRENT_SYSTEM}.runTests"
nix build .#checks.${CURRENT_SYSTEM}.runTests

echo "--- Full Workflow Completed ---"
echo "The code has been committed, and tests have been run via Nix."
echo "You can find the test logs in the Nix store output (e.g., result/test_output.log)."