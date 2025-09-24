#!/usr/bin/env bash

# ==============================================================================
#
#          FILE: inject_solfunmeme_env.sh
#
#         USAGE: ./scripts/env/inject_solfunmeme_env.sh <target_directory>
#
#   DESCRIPTION: This script injects a "solfunmeme" environment into a target
#                directory. It copies `boot.sh` and suggests copying SOPs and
#                CRQs. The name "solfunmeme" is quite specific and might refer
#                to a particular project or concept.
#
# ==============================================================================

set -euo pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <target_directory>"
  exit 1
fi

TARGET_DIR="$1"
ROOT_DIR="/data/data/com.termux.nix/files/home/pick-up-nix2"

echo "Injecting Gemini CLI environment into $TARGET_DIR"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy boot.sh
echo "Copying boot.sh..."
cp "$ROOT_DIR/boot.sh" "$TARGET_DIR/boot.sh"

# Placeholder for copying docs/sops and crqs - user needs to specify which ones
echo "Please specify which docs/sops/ and crqs files/directories to copy."
# Example: cp -r "$ROOT_DIR/docs/sops/some_sop.md" "$TARGET_DIR/docs/sops/"
# Example: cp -r "$ROOT_DIR/docs/crqs/some_crq.md" "$TARGET_DIR/docs/crqs/"

echo "Injection script finished."
