#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# This script iterates through all Git submodules (including nested ones)
# and executes a given command within each submodule's directory.

# Usage: ./submodule_tool_foreach.sh <command> [args...]
# Example: ./submodule_tool_foreach.sh ls -la
# Example: ./submodule_tool_foreach.sh git status
# Example: ./submodule_tool_foreach.sh /path/to/wikidata_tool --check-repo

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <command> [args...]"
    echo "Executes the given command in each Git submodule's directory."
    echo "Example: $0 ls -la"
    echo "Example: $0 git status"
    exit 1
fi

COMMAND="$*"

echo "Executing command '$COMMAND' in each submodule..."
echo "--------------------------------------------------"

# Use git submodule foreach to run the command in each submodule.
# The --recursive flag ensures nested submodules are also processed.
git submodule foreach --recursive bash -c "'$COMMAND'"

echo "--------------------------------------------------"
echo "Command execution complete for all submodules."
