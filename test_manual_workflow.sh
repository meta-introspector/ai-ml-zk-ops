#!/usr/bin/env bash

set -e

# Assuming the script is run from the ai-ml-zk-ops directory
# No explicit cd needed if already in the correct directory.

echo "--- Running nix flake update ---"
nix flake update

echo "--- Running run_workflow.sh ---"
./run_workflow.sh

echo "--- Test workflow completed successfully ---"
