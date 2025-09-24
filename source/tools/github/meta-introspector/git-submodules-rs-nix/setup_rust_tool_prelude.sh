#!/usr/bin/env bash

set -euo pipefail

PRELUDE_REPO_URL="https://github.com/meta-introspector/rust-tool-prelude"
PRELUDE_LOCAL_PATH="rust-tool-prelude-temp"

echo "--- Setting up Rust Tool Prelude repository ---"

# 1. Clean up any existing local directory
echo "1. Cleaning up existing local directory: ${PRELUDE_LOCAL_PATH}"
rm -rf "${PRELUDE_LOCAL_PATH}"

# 2. Create the directory
echo "2. Creating local directory: ${PRELUDE_LOCAL_PATH}"
mkdir -p "${PRELUDE_LOCAL_PATH}"

# 3. Initialize a new Git repository and populate it
echo "3. Initializing Git repository and populating with basic files..."
( # Run in a subshell to avoid changing current directory permanently
  cd "${PRELUDE_LOCAL_PATH}"
  git init --initial-branch=main

  # Create basic Cargo.toml
  mkdir -p src
  echo '[package]
name = "rust-tool-prelude"
version = "0.1.0"
edition = "2021"

[dependencies]
' > Cargo.toml

  # Create basic src/lib.rs
  echo 'pub fn common_utility() {
    println!("Hello from Rust Tool Prelude!");
}
' > src/lib.rs

  # Create basic README.md
  echo '# Rust Tool Prelude

This repository contains common utilities and boilerplate for Rust tools.
' > README.md

  git add Cargo.toml src/lib.rs README.md
  git commit -m "Initial commit for Rust Tool Prelude"

  git remote add origin "${PRELUDE_REPO_URL}"
  echo "Pushing initial prelude to remote: ${PRELUDE_REPO_URL} (force push)"
  git push -f -u origin main # Force push to overwrite remote history
)

echo "--- Rust Tool Prelude setup complete ---"
