#!/usr/bin/env bash
#
# Filename: doit.sh
# Description: This script serves as a simple entry point to execute the main
#              build workflow defined in `build.sh`. It adheres to the
#              "univalent idea" by taking no parameters and directly invoking
#              the primary build process.
#
# Usage:
#   ./doit.sh
#
# Output:
#   The output of `build.sh`, which includes the generation of 2gram.csv,
#   2gram.json, and the Nix flake's default package build.
#
# Rules Adhered To:
#   - Univalent idea: Takes no parameters and "does what I mean" (DWIM).
#   - Orchestrates complex commands (calling build.sh).
#
# Nix Flakes Context:
#   This script provides a convenient way to trigger the entire Nix-based
#   analysis and build process, making it easy for users to initiate the
#   workflow without needing to remember the specific `build.sh` command.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define the path to the build script
BUILD_SCRIPT="${SCRIPT_DIR}/build.sh"

echo "--- Starting DoIt Workflow ---"
echo "Invoking build.sh..."

# Execute build.sh
"$BUILD_SCRIPT"

echo "--- DoIt Workflow Completed ---"
echo "The build process has finished."
