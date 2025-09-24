#!/usr/bin/env bash

# This script helps manage the yearly GitHub repository for streamofrandom logs and data.
# It checks if the current year's directory exists within the streamofrandom submodule.
# If not, it suggests creating a new GitHub repository and then creates the year directory.

STREAMOFRANDOM_PATH="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/streamofrandom"
CURRENT_YEAR=$(date +"%Y")
YEAR_DIR="$STREAMOFRANDOM_PATH/$CURRENT_YEAR"

echo "Checking for year directory: $YEAR_DIR"

if [ ! -d "$YEAR_DIR" ]; then
  echo "Year directory for $CURRENT_YEAR not found."
  echo "It is recommended to create a new GitHub repository for this year's data."
  echo "You can do this manually using the 'gh' CLI tool:"
  echo "  gh repo create streamofrandom-$CURRENT_YEAR --public --description \"Logs and data for streamofrandom in $CURRENT_YEAR\""
  echo ""
  echo "After creating the GitHub repository, this script will create the local year directory."
  read -p "Press Enter to continue and create the local year directory, or Ctrl+C to cancel."

  mkdir -p "$YEAR_DIR"
  if [ $? -eq 0 ]; then
    echo "Successfully created local year directory: $YEAR_DIR"
  else
    echo "Failed to create local year directory: $YEAR_DIR"
    exit 1
  fi
else
  echo "Year directory for $CURRENT_YEAR already exists: $YEAR_DIR"
fi

echo "Happy New Year setup complete."
