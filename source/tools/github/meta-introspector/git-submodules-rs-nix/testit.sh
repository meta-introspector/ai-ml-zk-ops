#!/usr/bin/env bash

# This script runs the Nix build for the Emacs environment and then checks if Magit is available.

echo "--- Running Emacs environment build and Magit availability check ---"

EMACS_CONFIG_DIR="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/.emacs.d/terlar-emacs-config"

# Step 1: Build the Emacs environment
echo "Building emacs-env..."
cd "$EMACS_CONFIG_DIR" || { echo "Error: Could not change to Emacs config directory."; exit 1; }
nix build .#emacs-env

if ! nix build .#emacs-env; then
    echo "FAILURE: Nix build for emacs-env failed."
    exit 1
fi

echo "Emacs environment built successfully."

# Step 2: Check Magit availability within the Nix development shell using Emacs batch mode
echo "Checking Magit availability in Emacs batch mode..."

MAGIT_STATUS=$(nix develop --command emacs --batch --eval "(princ (format \"Magit loaded: %s\\n\" (featurep 'magit)))")

if ! nix develop --command emacs --batch --eval "(princ (format \"Magit loaded: %s\\n\" (featurep 'magit)))"; then
    echo "FAILURE: Emacs batch mode command failed."
    exit 1
fi

echo "--- Magit Status from Emacs ---"
echo "$MAGIT_STATUS"
echo "-------------------------------"

if echo "$MAGIT_STATUS" | grep -q "Magit loaded: t"; then
    echo "SUCCESS: Magit is loaded in Emacs."
    exit 0
else
    echo "FAILURE: Magit is NOT loaded in Emacs."
    exit 1
fi
