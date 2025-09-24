#!/usr/bin/env bash

set -euo pipefail

# This script adds a Git submodule to the current repository.
# It takes two arguments: the repository URL and the path where the submodule should be added.

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repository_url> <submodule_path>"
    echo "Example: $0 https://github.com/user/repo vendor/nix/repo"
    exit 1
fi

REPO_URL="$1"
SUBMODULE_PATH="$2"

echo "Adding submodule $REPO_URL to $SUBMODULE_PATH..."
git submodule add "$REPO_URL" "$SUBMODULE_PATH"

echo "Submodule added successfully."
