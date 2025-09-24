#!/usr/bin/env bash

set -euo pipefail

TEMPLATE_REPO_URL="https://github.com/meta-introspector/qa-incident-template"
TEMPLATE_SUBMODULE_PATH="qa/templates/incident"

echo "--- Setting up incident template submodule ---"

# 1. Clean up any existing template directory and git metadata
echo "1. Cleaning up existing template directory and git metadata..."
rm -rf "${TEMPLATE_SUBMODULE_PATH}"
rm -rf ".git/modules/${TEMPLATE_SUBMODULE_PATH}"

# 2. Create the directory
echo "2. Creating template directory: ${TEMPLATE_SUBMODULE_PATH}"
mkdir -p "${TEMPLATE_SUBMODULE_PATH}"

# 3. Initialize a new Git repository and populate it
echo "3. Initializing Git repository and populating with issue.md..."
( # Run in a subshell to avoid changing current directory permanently
  cd "${TEMPLATE_SUBMODULE_PATH}"
  git init --initial-branch=main
  printf '%s\n\n%s\n' "# Incident Template" "This is a template for incident reports." > issue.md
  git add issue.md
  git commit -m "Initial incident template"
  git remote add origin "${TEMPLATE_REPO_URL}"
  echo "Pushing initial template to remote: ${TEMPLATE_REPO_URL} (force push)"
  git push -f -u origin main # Force push to overwrite remote history
)

# 4. Add the repository as a submodule to the parent project
echo "4. Adding ${TEMPLATE_REPO_URL} as a submodule at ${TEMPLATE_SUBMODULE_PATH}..."
git submodule add "${TEMPLATE_REPO_URL}" "${TEMPLATE_SUBMODULE_PATH}"

# 5. Commit the submodule addition to the parent repository
echo "5. Committing submodule addition to parent repository..."
git add .gitmodules "${TEMPLATE_SUBMODULE_PATH}"
git commit -m "Add qa-incident-template as a submodule for incident templates."

echo "--- Incident template submodule setup complete ---"