#!/usr/bin/env bash

set -euo pipefail

TOOL_TEMPLATE_REPO_URL="https://github.com/meta-introspector/tool-template-repo"
TOOL_TEMPLATE_SUBMODULE_PATH="tools/tool-template"

echo "--- Setting up tool template submodule ---"

# 1. Clean up any existing directory and git metadata
echo "1. Cleaning up existing template directory and git metadata..."
rm -rf "${TOOL_TEMPLATE_SUBMODULE_PATH}"
rm -rf ".git/modules/${TOOL_TEMPLATE_SUBMODULE_PATH}"

# 2. Create the directory
echo "2. Creating template directory: ${TOOL_TEMPLATE_SUBMODULE_PATH}"
mkdir -p "${TOOL_TEMPLATE_SUBMODULE_PATH}"

# 3. Initialize a new Git repository and populate it
echo "3. Initializing Git repository and populating with basic files..."
( # Run in a subshell to avoid changing current directory permanently
  cd "${TOOL_TEMPLATE_SUBMODULE_PATH}"
  git init --initial-branch=main

  # Create basic Cargo.toml
  mkdir -p src
  echo '[package]
name = "tool-template"
version = "0.1.0"
edition = "2021"

[dependencies]
' > Cargo.toml

  # Create basic src/main.rs
  echo 'fn main() {
    println!("Hello from tool template!");
}
' > src/main.rs

  # Create basic README.md
  echo '# Tool Template

This is a template repository for new tools.
' > README.md

  # Add placeholder for prelude submodule (will be an empty directory for now)
  mkdir -p prelude
  echo '# Prelude

This directory is a placeholder for the prelude submodule.
' > prelude/README.md

  git add Cargo.toml src/main.rs README.md prelude/README.md
  git commit -m "Initial tool template with basic structure and prelude placeholder"

  git remote add origin "${TOOL_TEMPLATE_REPO_URL}"
  echo "Pushing initial template to remote: ${TOOL_TEMPLATE_REPO_URL} (force push)"
  git push -f -u origin main # Force push to overwrite remote history
)

# 4. Add the repository as a submodule to the parent project
echo "4. Adding ${TOOL_TEMPLATE_REPO_URL} as a submodule at ${TOOL_TEMPLATE_SUBMODULE_PATH}..."
git submodule add "${TOOL_TEMPLATE_REPO_URL}" "${TOOL_TEMPLATE_SUBMODULE_PATH}"

# 5. Commit the submodule addition to the parent repository
echo "5. Committing submodule addition to parent repository..."
git add .gitmodules "${TOOL_TEMPLATE_SUBMODULE_PATH}"
git commit -m "Add tool-template-repo as a submodule for new tool templates."

echo "--- Tool template submodule setup complete ---"
