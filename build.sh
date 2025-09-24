#!/usr/bin/env bash
#
# Filename: build.sh
# Description: This script orchestrates the entire 2-gram repository analysis workflow.
#              It generates the 2-gram CSV, converts it to JSON, and then builds
#              the Nix flake's default package, which consumes this JSON data.
#              Adheres to the "univalent idea" by taking no parameters and
#              deriving its context from its execution environment.
#
# Usage:
#   ./build.sh
#
# Output:
#   - 2gram.csv: CSV file containing the top 80 2-gram repository analysis.
#   - 2gram.json: JSON representation of the 2-gram analysis.
#   - A Nix store path containing the output of the defaultPackage (e.g., a report file).
#
# Rules Adhered To:
#   - All complex commands are wrapped in dedicated scripts or functions.
#   - Univalent idea: The script takes no parameters and "does what I mean" (DWIM).
#   - Context on the stack: Paths are resolved relative to the script's location.
#
# Nix Flakes Context:
#   This script demonstrates a complete workflow for integrating external data
#   analysis (2-gram repository analysis) into a Nix flake. It showcases how
#   to prepare data (CSV to JSON conversion) for consumption by Nix expressions
#   and how to build a Nix derivation that utilizes this data.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Define paths to the helper scripts
GENERATE_CSV_SCRIPT="${SCRIPT_DIR}/source/automation/generate_repo_2gram_csv.sh"
CONVERT_JSON_SCRIPT="${SCRIPT_DIR}/source/automation/convert_2gram_csv_to_json.sh"

echo "--- Starting 2-gram Repository Analysis Workflow ---"

# Step 1: Build the Nix flake's default package
echo "1. Building Nix flake default package..."
# Set NIX_CONFIG to enable experimental features
export NIX_CONFIG="experimental-features = nix-command flakes"

echo "   Executing: nix build .#defaultPackage"
nix build .#defaultPackage
echo "   Nix flake default package built successfully."

echo "--- Workflow Completed ---"
echo "You can find the generated report in the result/report.txt symlink."
