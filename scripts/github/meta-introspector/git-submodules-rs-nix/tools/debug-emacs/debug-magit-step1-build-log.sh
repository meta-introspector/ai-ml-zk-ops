#!/usr/bin/env bash

# Script to capture Nix build logs for the emacs-env package.
# Corresponds to SOP step 3.1: Verify Nix Build Logs.

# Navigate to the directory containing flake.nix
cd /data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/.emacs.d/terlar-emacs-config/ || { echo "Error: Could not change to Emacs config directory."; exit 1; }

echo "Building emacs-env and capturing logs to emacs-env-build.log..."
nix build .#emacs-env --log-format raw > emacs-env-build.log 2>&1

if nix build .#emacs-env --log-format raw > emacs-env-build.log 2>&1; then
    echo "Nix build completed. Logs saved to emacs-env-build.log"
else
    echo "Nix build failed. Check emacs-env-build.log for details."
fi
