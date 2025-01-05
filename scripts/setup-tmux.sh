#!/bin/bash

SESSION_NAME="modern_template"
SERVE_COMMAND="bun run serve"

# Start a new tmux session in detached mode
tmux new-session -d -s "$SESSION_NAME"

# Split the window vertically: Left (main pane) and Right
tmux split-window -h -t "$SESSION_NAME"

# Focus on the right pane and split it horizontally
tmux select-pane -t "$SESSION_NAME:0.1"
tmux split-window -v -t "$SESSION_NAME"

# Resize panes if necessary (optional)
# Adjust the percentage as per your preference
tmux select-pane -t "$SESSION_NAME:0.0"
tmux resize-pane -x 60

# Run 'bun run watch' in the main (left) pane
tmux send-keys -t "$SESSION_NAME:0.0" 'bun run watch' C-m

# Run the serving command in the top-right pane
tmux send-keys -t "$SESSION_NAME:0.1" "$SERVE_COMMAND" C-m

# The bottom-right pane is left empty for commands

# Attach to the tmux session
tmux attach-session -t "$SESSION_NAME"
