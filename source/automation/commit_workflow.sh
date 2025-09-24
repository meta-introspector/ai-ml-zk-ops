#!/usr/bin/env bash

set -e

# --- Configuration ---
BRANCH_NAME="feature/CRQ-016-nixify-workflow"
COMMIT_MESSAGE_FILE=".git_commit_message.txt" # This will be created in the target directory

# --- Argument Parsing ---
TARGET_DIRECTORY="${1}" # Get the first argument

# If TARGET_DIRECTORY is not provided, try to read it from context/task_cwd.txt
if [ -z "$TARGET_DIRECTORY" ]; then
  CONTEXT_FILE="context/task_cwd.txt" # Path relative to the script's execution location
  if [ -f "$CONTEXT_FILE" ]; then
    TARGET_DIRECTORY=$(cat "$CONTEXT_FILE")
    echo "--- Using TARGET_DIRECTORY from $CONTEXT_FILE: $TARGET_DIRECTORY ---"
  else
    TARGET_DIRECTORY="." # Default to current directory if no argument and no context file
    echo "--- No TARGET_DIRECTORY provided and no context file found. Defaulting to current directory: $TARGET_DIRECTORY ---"
  fi
fi

echo "--- Committing changes in directory: $TARGET_DIRECTORY ---"

(
  cd "$TARGET_DIRECTORY" || exit 1

  # --- 1. Create or Checkout Branch ---
  echo "--- Creating or checking out branch: $BRANCH_NAME ---"
  if git rev-parse --verify "$BRANCH_NAME" &>/dev/null; then
      echo "Branch $BRANCH_NAME already exists. Checking it out."
      git checkout "$BRANCH_NAME"
  else
      echo "Branch $BRANCH_NAME does not exist. Creating and checking it out."
      git checkout -b "$BRANCH_NAME"
  fi

  # --- 2. Stage Files ---
  echo "--- Staging all new and modified files ---"
  git add .

  # --- 3. Generate Commit Message ---
  echo "--- Generating commit message ---"
  COMMIT_MESSAGE_CONTENT="feat(experiment): Add Unimath CRQ and MiniZinc/Nix experiment files"

  # --- 4. Create Commit Message File ---
  echo "--- Creating commit message file ---"
  echo "$COMMIT_MESSAGE_CONTENT" > "$COMMIT_MESSAGE_FILE"

  # --- 5. Commit ---
  echo "--- Committing changes ---"
  git commit -F "$COMMIT_MESSAGE_FILE"

  echo "--- Commit successful! ---"
)
