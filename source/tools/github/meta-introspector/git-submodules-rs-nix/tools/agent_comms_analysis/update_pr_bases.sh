#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Fetching list of open pull requests..."

# Get PR numbers and pass them to xargs
gh pr list --json number | jq -r '.[].number' | while read -r pr_number; do
  echo "--------------------------------------------------"
  echo "Processing PR #$pr_number"
  echo "--------------------------------------------------"

  if gh pr edit "$pr_number" --base main; then
    echo "Successfully updated base branch of PR #$pr_number to 'main'."
  else
    echo "Failed to update base branch of PR #$pr_number. Please check for errors."
  fi
done

echo "--------------------------------------------------"
echo "All open pull requests processed."
echo "Script finished."