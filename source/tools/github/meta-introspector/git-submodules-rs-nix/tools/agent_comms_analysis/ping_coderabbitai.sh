#!/usr/bin/env bash

set -e

echo "Starting script to ping @coderabbitai on PRs if no response yet..."

PR_NUMBERS=$(gh pr list --json number | jq -r '.[].number')

if [ -z "$PR_NUMBERS" ]; then
  echo "No open pull requests found."
  exit 0
fi

for pr_number in $PR_NUMBERS; do
  echo "--------------------------------------------------"
  echo "Processing PR #$pr_number"
  echo "--------------------------------------------------"

  # Fetch comments for the PR
  COMMENTS_JSON=$(gh pr view "$pr_number" --json comments)

  # Check if @coderabbitai has commented
  # This jq command checks if any comment has 'author.login' equal to 'coderabbitai'
  HAS_CODERABBITAI_COMMENT=$(echo "$COMMENTS_JSON" | jq -r '.comments[] | select(.author.login == "coderabbitai") | .author.login' | head -n 1)

  if [ -z "$HAS_CODERABBITAI_COMMENT" ]; then
    echo "No comment from @coderabbitai found on PR #$pr_number. Pinging..."
    if gh pr comment "$pr_number" --body "@coderabbitai review the ticket."; then
      echo "Successfully pinged @coderabbitai on PR #$pr_number."
    else
      echo "Failed to ping @coderabbitai on PR #$pr_number. Please check for errors."
    fi
  else
    echo "@coderabbitai has already commented on PR #$pr_number. Skipping."
  fi
done

echo "--------------------------------------------------"
echo "Script finished."
