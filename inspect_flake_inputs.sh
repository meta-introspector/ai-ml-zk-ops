#!/usr/bin/env bash
#
# Filename: inspect_flake_inputs.sh
# Description: This script runs 'nix flake metadata --json' on the main flake
#              to inspect how Nix is resolving its inputs.
#
# Usage:
#   ./inspect_flake_inputs.sh
#

set -e

# Determine the directory where this script is located (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

nix flake metadata --json "$SCRIPT_DIR"