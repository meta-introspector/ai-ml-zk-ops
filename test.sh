#!/usr/bin/env bash
#
# Filename: test.sh
# Description: This script executes the main build workflow (`build.sh`)
#              and captures its entire output (stdout and stderr) into a
#              timestamped log file within the 'logs/' directory.
#              This provides a standard, version-controlled-ignored logging
#              system for build and test runs.
#
# Usage:
#   ./test.sh
#
# Output:
#   - A log file in the 'logs/' directory named `build_YYYYMMDD_HHMMSS.log`
#     containing all output from `build.sh`.
#   - Console output indicating the log file location.
#
# Rules Adhered To:
#   - Standard logging system outside the Git repository (via .gitignore).
#   - Orchestrates complex commands (calling build.sh).
#   - Univalent idea: Takes no parameters and "does what I mean" (DWIM).
#
# Nix Flakes Context:
#   This script is crucial for maintaining a clear audit trail of Nix build
#   processes. In a Nix environment, reproducibility is key, and detailed logs
#   help in debugging build failures, verifying expected outputs, and ensuring
#   that the flake behaves consistently across different runs and environments.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define the path to the build script
BUILD_SCRIPT="${SCRIPT_DIR}/build.sh"

# Define the log directory and filename
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/build_$(date +%Y%m%d_%H%M%S).log"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

echo "--- Starting Test Workflow ---"
echo "Executing build.sh and logging output to: $LOG_FILE"

# Execute build.sh and redirect all output to the log file
# The 'tee' command can be used if you also want to see output on console
# "$BUILD_SCRIPT" &> "$LOG_FILE"
# For now, let's just redirect to file as requested for logging.
"$BUILD_SCRIPT" > "$LOG_FILE" 2>&1

echo "--- Test Workflow Completed ---"
echo "All build output has been logged to: $LOG_FILE"
echo "You can inspect the log file for details."
