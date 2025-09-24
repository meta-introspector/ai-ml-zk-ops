#!/usr/bin/env bash
set -x # Enable debugging

# Script to inspect the Nix store path for the emacs-env package and search for Magit files.
# Corresponds to SOP step 3.2: Inspect Nix Store.

EMACS_CONFIG_DIR="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/.emacs.d/terlar-emacs-config"
OUTPUT_LOG_FILE="$EMACS_CONFIG_DIR/emacs-env-store-contents.log" # New log file name for broader contents

echo "Attempting to find the Nix store path for emacs-env..."

# Find the result symlink from the previous build
# This assumes the previous build was successful and created a 'result' symlink
RESULT_PATH=$(find "$EMACS_CONFIG_DIR" -maxdepth 1 -type l -name "result" -print -quit)

if [ -z "$RESULT_PATH" ]; then
    echo "Error: 'result' symlink not found in $EMACS_CONFIG_DIR. Please run debug-magit-step1-build-log.sh first and ensure it succeeds."
    exit 1
fi

# Resolve the actual Nix store path
NIX_STORE_PATH=$(readlink -f "$RESULT_PATH")

if [ -z "$NIX_STORE_PATH" ]; then
    echo "Error: Could not resolve Nix store path from $RESULT_PATH."
    exit 1
fi

echo "Nix store path for emacs-env: $NIX_STORE_PATH"
echo "Listing all contents of the Nix store path and saving to $OUTPUT_LOG_FILE..."

echo "OUTPUT_LOG_FILE is: $OUTPUT_LOG_FILE" # Debugging echo

# List all contents recursively
if ls -R "$NIX_STORE_PATH" > "$OUTPUT_LOG_FILE" 2>&1; then
    echo "Nix store contents listed. Output saved to $OUTPUT_LOG_FILE"
else
    echo "Failed to list Nix store contents. Check $OUTPUT_LOG_FILE for details."
fi