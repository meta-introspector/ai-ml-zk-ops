#!/usr/bin/env bash

set -e

echo "Starting to collect all PR data into the current branch..."

# Create a central directory for analysis data
ANALYSIS_DATA_DIR="analysis_data" # This will be the root for comms/git
mkdir -p "$ANALYSIS_DATA_DIR"

# Get list of open PRs with their associated headRefName (branch name)
# and number.
PR_LIST=$(gh pr list --json number,headRefName,title) # Also get title to extract CRQ_ID early

if [ -z "$PR_LIST" ]; then
  echo "No open pull requests found."
  exit 0
fi

# Parse PR list using jq
echo "$PR_LIST" | jq -c '.[]' | while read -r pr_entry; do
  PR_NUMBER=$(echo "$pr_entry" | jq -r '.number')
  BRANCH_NAME=$(echo "$pr_entry" | jq -r '.headRefName')
  PR_TITLE=$(echo "$pr_entry" | jq -r '.title') # Extract title here

  # Extract CRQ ID from PR title (assuming format "CRQ-XXX: ...")
  CRQ_ID=$(echo "$PR_TITLE" | grep -oP 'CRQ-\d+' || echo "PR-$PR_NUMBER") # Extract CRQ-XXX, fallback if not found

  echo "--------------------------------------------------"
  echo "Processing PR #$PR_NUMBER (CRQ: $CRQ_ID) from branch '$BRANCH_NAME'"
  echo "--------------------------------------------------"

  # Call mirror_pr_to_fs.sh to collect data into ANALYSIS_DATA_DIR
  if /data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules/tools/agent_comms_analysis/mirror_pr_to_fs.sh "$PR_NUMBER" "$ANALYSIS_DATA_DIR"; then
    echo "Successfully collected PR #$PR_NUMBER data into $ANALYSIS_DATA_DIR."
  else
    echo "Failed to collect PR #$PR_NUMBER data. Please check mirror_pr_to_fs.sh errors."
  fi

done

echo "--------------------------------------------------"
echo "All PR data collected into '$ANALYSIS_DATA_DIR'."
echo "Script finished."
