#!/usr/bin/env bash

FLAKE_PATH="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/sources/ironthree/cargoman"
LOG_FILE="nix_build_debug_cargoman.log"
STRACE_LOG_FILE="nix_build_strace_cargoman.log"

echo "Attempting to build flake: $FLAKE_PATH" | tee "$LOG_FILE"
nix build "$FLAKE_PATH" 2>&1 | tee -a "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}

if [ "$EXIT_CODE" -eq 139 ]; then
    echo "Build failed with Segmentation Fault (Exit Code 139)." | tee -a "$LOG_FILE"
    echo "Attempting to reproduce with strace..." | tee -a "$LOG_FILE"
    strace -o "$STRACE_LOG_FILE" nix build "$FLAKE_PATH" 2>&1 | tee -a "$LOG_FILE"
    echo "strace output saved to $STRACE_LOG_FILE" | tee -a "$LOG_FILE"
else
    echo "Build completed with exit code: $EXIT_CODE" | tee -a "$LOG_FILE"
fi

echo "Debug process complete. Check $LOG_FILE and $STRACE_LOG_FILE for details."
