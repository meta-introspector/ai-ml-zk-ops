#!/usr/bin/env bash

# This script generates a FIGlet banner for livestream display.

MESSAGE="$*"

if [ -z "$MESSAGE" ]; then
  echo "Usage: $0 <your message here>"
  exit 1
fi

if ! command -v figlet &> /dev/null
then
    echo "Error: figlet is not installed. Please install it to use this script."
    exit 1
fi

figlet "$MESSAGE"
