#!/usr/bin/env bash
#
# Filename: commit.sh
# Description: This script stages all current changes in the Git repository
#              and commits them with a user-provided commit message.
#              It's a wrapper for `git add .` and `git commit -m`.
#
# Usage:
#   ./commit.sh "Your commit message here"
#
# Arguments:
#   $1: The commit message (required).
#
# Rules Adhered To:
#   - Univalent idea: Simple wrapper for a common Git operation.
#
# Nix Flakes Context:
#   Committing changes is a prerequisite for reproducible Nix operations,
#   as Nix flakes operate on a committed, immutable state of the repository.
#   This script facilitates adhering to the "Commit Before Nix Operations" SOP.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if a commit message is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a commit message."
  echo "Usage: ./commit.sh \"Your commit message here\""
  exit 1
fi

COMMIT_MESSAGE="$1"

echo "--- Starting Commit Workflow ---"

# Stage all changes
echo "1. Staging all changes..."
git add .

# Commit the changes
echo "2. Committing changes with message: \"$COMMIT_MESSAGE\""
git commit -m "$COMMIT_MESSAGE"

echo "--- Commit Workflow Completed ---"
echo "Changes have been committed."
