#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# This script iterates through submodules defined in submod.toml
# and executes a given command within each submodule's directory.

# Usage: ./submod_foreach.sh <command> [args...]
# Example: ./submod_foreach.sh ls -la
# Example: ./submod_foreach.sh cargo check
# Example: ./submod_foreach.sh /path/to/wikidata_tool --check-repo

SUBMOD_TOML="submod.toml"

if [ ! -f "$SUBMOD_TOML" ]; then
    echo "Error: $SUBMOD_TOML not found in the current directory." >&2
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <command> [args...]"
    echo "Executes the given command in each submodule's directory as defined in $SUBMOD_TOML."
    echo "Example: $0 ls -la"
    echo "Example: $0 cargo check"
    exit 1
fi

COMMAND="$*"

echo "Extracting submodule paths from $SUBMOD_TOML..."

# Extract paths from submod.toml
# This looks for lines like 'path = "some_path"' and extracts 'some_path'
SUBMODULE_PATHS=$(grep -E '^path = "[^"]+"$' "$SUBMOD_TOML" | sed -E 's/^path = "([^"]+)"/
1/')

if [ -z "$SUBMODULE_PATHS" ]; then
    echo "No submodule paths found in $SUBMOD_TOML." >&2
    exit 1
fi

printf "Executing command '%s' in each submodule...\n" "$COMMAND"
echo "--------------------------------------------------"

for submodule_path in $SUBMODULE_PATHS; do
    if [ -d "$submodule_path" ]; then
        printf "\n--- Entering submodule: %s ---\n" "$submodule_path"
        (cd "$submodule_path" && eval "$COMMAND")
        echo "--- Exiting submodule: $submodule_path ---"
    else
        printf "\nWarning: Submodule path '%s' not found or is not a directory. Skipping.\n" "$submodule_path" >&2
    fi
done

echo "--------------------------------------------------"
echo "Command execution complete for all submodules defined in $SUBMOD_TOML."

