#!/usr/bin/env bash

REPO_URL="https://github.com/meta-introspector/git-submodules-rs-nix.git"
SUBMODULE_DIR="temp_crq_submodules"

echo "Creating $SUBMODULE_DIR directory..."
mkdir -p "$SUBMODULE_DIR"

echo "Adding CRQ branches as submodules..."

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch is: $CURRENT_BRANCH"

# Get all local branches and filter for CRQ branches
git branch --list "feature/CRQ-*-*" | while read -r branch_name; do
    # Remove leading whitespace
    branch_name=$(echo "$branch_name" | xargs)

    # Skip the current branch
    if [[ "$branch_name" == "$CURRENT_BRANCH" ]]; then
        echo "Skipping current branch: $branch_name"
        continue
    fi

    # Sanitize branch name for directory
    sanitized_name=${branch_name//[^a-zA-Z0-9_.-]/_}

    echo "Adding submodule for branch: $branch_name at $SUBMODULE_DIR/$sanitized_name"
    git submodule add -b "$branch_name" "$REPO_URL" "$SUBMODULE_DIR/$sanitized_name"
done

echo "Submodule addition process complete. Remember to run 'git submodule update --init --recursive' if needed."
echo "You can now inspect the submodules in the '$SUBMODULE_DIR' directory."
