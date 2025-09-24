#!/usr/bin/env bash
#
# Filename: force_flake_re_evaluation.sh
# Description: Forces Nix to re-evaluate flakes by removing flake.lock and updating.
#
# Usage:
#   ./force_flake_re_evaluation.sh <flake_path>
#
# Arguments:
#   <flake_path>: The absolute path to the flake directory (e.g., /path/to/your/flake)
#
# This script is intended to be called by run_workflow.sh when a full flake re-evaluation
# is required, typically to resolve caching issues where Nix uses outdated store paths.
#

set -e

FLAKE_PATH="$1"

if [ -z "$FLAKE_PATH" ]; then
  echo "Error: Flake path not provided."
  exit 1
fi

echo "  Removing flake.lock for $FLAKE_PATH..."
rm -f "$FLAKE_PATH/flake.lock"

echo "  Running nix flake update for $FLAKE_PATH..."
nix flake update "$FLAKE_PATH"

echo "  Flake re-evaluation complete for $FLAKE_PATH."