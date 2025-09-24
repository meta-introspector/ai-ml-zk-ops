#!/usr/bin/env bash

source "$(dirname "$0")"/../../scripts/lib_git_submodule.sh

CRQ_FILE="$1"

if [ -z "$CRQ_FILE" ]; then
  echo "Usage: $0 <path_to_crq_file.md>"
  exit 1
fi

if [ ! -f "$CRQ_FILE" ]; then
  echo "Error: CRQ file not found at $CRQ_FILE"
  exit 1
fi

# Read the entire CRQ file content for the PR body
PR_BODY_CONTENT=$(cat "$CRQ_FILE")

# Extract CRQ Number and Title
CRQ_NUMBER=$(basename "$CRQ_FILE" | grep -oP 'CRQ-\K[0-9]+')
CRQ_TITLE=$(grep -m 1 "^## Change Request:" "$CRQ_FILE" | sed 's/## Change Request: //g' | tr -d '\r')

if [ -z "$CRQ_NUMBER" ] || [ -z "$CRQ_TITLE" ]; then
  echo "Error: Could not extract CRQ number or title from $CRQ_FILE"
  exit 1
fi

# Extract Objective and Description for task.md (more lines for gist)
OBJECTIVE_SECTION=$(awk '/### Objective/{flag=1;next}/### Description/{flag=0}flag' "$CRQ_FILE" | head -n 3 | sed 's/^[[:space:]]*//' | tr -d '\r')
DESCRIPTION_SECTION=$(awk '/### Description/{flag=1;next}/### Expected Outcome/{flag=0}flag' "$CRQ_FILE" | head -n 3 | sed 's/^[[:space:]]*//' | tr -d '\r')

# Sanitize title for branch name
BRANCH_TITLE=$(echo "$CRQ_TITLE" | sed 's/[^a-zA-Z0-9_ -]/ /g' | tr ' ' '-' | tr -s '-' | tr '[:upper:]' '[:lower:]')
BRANCH_NAME="feature/crq-${CRQ_NUMBER}-${BRANCH_TITLE}"

echo "Processing CRQ: CRQ-${CRQ_NUMBER} - ${CRQ_TITLE}"
echo "Branch Name: ${BRANCH_NAME}"

ensure_branch_exists_and_checkout "$BRANCH_NAME"

# Create task.md content
TASK_MD_CONTENT="# Task for CRQ-${CRQ_NUMBER}: ${CRQ_TITLE}

## Objective
${OBJECTIVE_SECTION}

## Description
${DESCRIPTION_SECTION}

Refer to ${CRQ_FILE} for full details.
"

# Write task.md
echo "$TASK_MD_CONTENT" > task.md

# Commit task.md
git_add_all # Assuming task.md is the only change to add
git_commit_message "feat: Add task.md for CRQ-${CRQ_NUMBER}: ${CRQ_TITLE}"

# Push the new branch to remote
push_to_origin_branch "$BRANCH_NAME"

# Create temporary file for PR body
PR_BODY_FILE=$(mktemp)
echo "$PR_BODY_CONTENT" > "$PR_BODY_FILE"

# Create Pull Request
gh pr create --title "CRQ-${CRQ_NUMBER}: ${CRQ_TITLE}" --body-file "$PR_BODY_FILE"

# Clean up temporary file
rm "$PR_BODY_FILE"

echo "Workflow completed for CRQ-${CRQ_NUMBER}."
