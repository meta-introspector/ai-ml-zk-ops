#!/usr/bin/env bash

# Helper script to send an Emacs Lisp command to a tmux pane and capture its output.

TMUX_TARGET="$1"
EMACS_LISP_COMMAND="$2"

if [ -z "$TMUX_TARGET" ] || [ -z "$EMACS_LISP_COMMAND" ]; then
    echo "Usage: $0 <tmux_target> <emacs_lisp_command>"
    exit 1
fi

# Clear the pane history before sending the command to get a clean capture
tmux clear-history -t "$TMUX_TARGET"

# Send the Emacs Lisp command to the pane
# We need to escape quotes for the Emacs Lisp command
ESCAPED_COMMAND=$(printf %q "$EMACS_LISP_COMMAND")
tmux send-keys -t "$TMUX_TARGET" "(progn ${ESCAPED_COMMAND} (message \"\"))" C-m

# Wait a moment for Emacs to process the command and update the display
sleep 0.5

# Capture the pane content
CAPTURED_CONTENT=$(tmux capture-pane -p -t "$TMUX_TARGET")

echo "--- Captured Pane Content ---"
echo "$CAPTURED_CONTENT"
echo "-----------------------------"

exit 0
