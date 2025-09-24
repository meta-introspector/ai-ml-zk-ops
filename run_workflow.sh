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
#   ./run_workflow.sh [--dry-run]
#
# Arguments:
#   --dry-run: Optional. If provided, the script will only print the commands
#              that would be executed, without actually running them.
#   None (default): The script reads its context from the environment and files.
#
# Output:
#   - Git commit of current changes (if any and commit message is provided).
#   - Output from the Nix flake's test check.
#
# Rules Adhered To:
#   - All complex commands are wrapped.
#   - Univalent idea: Takes no parameters and "does what I mean" (DWIM).
#   - Context on the stack: Paths are resolved relative to the script's location,
#     and commit message is sourced from the `context/` directory.
#   - Adaptive: Reads context (git status, commit message) to determine next steps.
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

# Initialize flags
DRY_RUN=false
FORCE_NIX_REBUILD=false # Flag to force Nix rebuild
COMMITTED_CHANGES=false # Flag to track if a commit actually happened

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=true
      shift # Remove --dry-run from processing
      ;;
    --force-nix-rebuild)
      FORCE_NIX_REBUILD=true
      shift # Remove --force-nix-rebuild from processing
      ;;
    *)
      # Unknown option
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define the path to the commit script and commit message file
COMMIT_SCRIPT="${SCRIPT_DIR}/commit.sh"
COMMIT_MESSAGE_FILE="${SCRIPT_DIR}/context/commit_message.txt"

echo "--- Starting Full Workflow ---"
if [ "$DRY_RUN" = true ]; then
  echo "--- DRY RUN ENABLED ---"
fi

# Step 1: Commit current changes (if any)
echo "1. Checking for changes to commit..."

# Check if there are any pending changes
if git status --porcelain | grep -q .; then
  echo "  Pending changes detected."

  # Read commit message from file
  if [ ! -f "$COMMIT_MESSAGE_FILE" ]; then
    echo "  Error: Commit message file not found at $COMMIT_MESSAGE_FILE. Cannot commit."
    exit 1 # Exit if commit message file is missing
  fi
  COMMIT_MESSAGE=$(cat "$COMMIT_MESSAGE_FILE")

  # Check if the commit message is empty
  if [ -z "$COMMIT_MESSAGE" ]; then
    echo "  Error: Commit message file is empty. Please provide a commit message in $COMMIT_MESSAGE_FILE. Cannot commit."
    exit 1 # Exit if commit message is empty
  fi

  if [ "$DRY_RUN" = true ]; then
    echo "  (Dry Run) Would execute: "$COMMIT_SCRIPT" "$COMMIT_MESSAGE""
  else
    echo "  Committing changes with message from $COMMIT_MESSAGE_FILE."
    echo "  Executing: "$COMMIT_SCRIPT" "$COMMIT_MESSAGE""
    "$COMMIT_SCRIPT" "$COMMIT_MESSAGE"
    echo "  Changes committed successfully."
    COMMITTED_CHANGES=true # Set flag as commit happened
  fi
else
  echo "  No pending changes detected. Skipping commit."
fi

# Step 2: Run the Nix flake's test check
echo "2. Running Nix flake tests (via checks.runTests)..."
export NIX_CONFIG="experimental-features = nix-command flakes"

# Get the current system
CURRENT_SYSTEM=$(nix eval --raw --impure --expr 'builtins.currentSystem')

NIX_REBUILD_FLAG=""
if [ "$FORCE_NIX_REBUILD" = true ]; then
  NIX_REBUILD_FLAG="--rebuild"
fi

if [ "$DRY_RUN" = true ]; then
  echo "  (Dry Run) Would execute: nix build $NIX_REBUILD_FLAG .#checks.${CURRENT_SYSTEM}.runTests"
else
  echo "  Executing: nix build $NIX_REBUILD_FLAG .#checks.${CURRENT_SYSTEM}.runTests"
  nix build $NIX_REBUILD_FLAG .#checks.${CURRENT_SYSTEM}.runTests
fi

if [ "$COMMITTED_CHANGES" = true ]; then
  echo "3. Pushing committed changes to remote..."
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$DRY_RUN" = true ]; then
    echo "  (Dry Run) Would execute: git push origin "$CURRENT_BRANCH""
  else
    echo "  Executing: git push origin "$CURRENT_BRANCH""
    if ! git push origin "$CURRENT_BRANCH"; then
      echo "  Error: Failed to push changes to origin/$CURRENT_BRANCH. Please resolve any conflicts or authentication issues manually."
      exit 1
    fi
    echo "  Changes pushed successfully to origin/$CURRENT_BRANCH."
  fi
else
  echo "3. No new changes were committed. Skipping push."
fi

echo "--- Full Workflow Completed ---"
if [ "$DRY_RUN" = true ]; then
  echo "--- DRY RUN: No commands were actually executed. ---"
else
  echo "The workflow has completed. If changes were present, they have been committed, and tests have been run via Nix."
  echo "You can find the test logs in the Nix store output (e.g., result/test_output.log)."
fi