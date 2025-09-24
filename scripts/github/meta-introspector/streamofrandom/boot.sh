#!/usr/bin/env bash

# This script launches Gemini with the current directory as context
# and provides access to the main project's root.

# Set the GEMINI_CLI_ROOT to the main project directory
export GEMINI_CLI_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2"

# Launch Gemini CLI, passing the current directory as the context
# and ensuring it has access to the main project's root.
# The actual command to launch gemini-cli might vary based on its installation.
# Assuming gemini-cli is in the main project's root or in PATH.

# Example: If gemini-cli is a script in the main project's root
"$GEMINI_CLI_ROOT/gemini_cli.sh" --context "$PWD"

# If gemini-cli is a globally installed command, you might just use:
# gemini-cli --context "$PWD"
