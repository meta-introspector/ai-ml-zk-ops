#!/usr/bin/env bash

SESSION_NAME="$1"
PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix/source/github/meta-introspector/submodules"

# Check if a tmux session name was provided
if [ -z "$SESSION_NAME" ]; then
  echo "Usage: $0 <tmux_session_name>"
  exit 1
fi

# Split the current window vertically (assuming the main CLI is in pane 0)
tmux split-window -v -t "$SESSION_NAME:0.0"

# Send commands to the new pane (pane 1)
# Set EMACS_HOME and launch Emacs
tmux send-keys -t "$SESSION_NAME:0.1" "export EMACS_HOME=\"$PROJECT_ROOT\" && emacs" C-m

# You might want to select the first pane again if the CLI is the primary interaction
# tmux select-pane -t "$SESSION_NAME:0.0"
