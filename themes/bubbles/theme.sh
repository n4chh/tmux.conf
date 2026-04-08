#!/usr/bin/env bash
tmux set status on
tmux set status-right-length 200
tmux set status-left-length 40
tmux set status-interval 1
tmux set status-left "#($PWD/left_status.sh $PWD)"
tmux set status-right "#($PWD/right_status.sh $PWD)"

# icons
# ''
# ''
# ''
# ''

tmux setw window-status-separator ' '
tmux setw window-status-format "#($PWD/window_status.sh $PWD)"
tmux setw window-status-current-format "#($PWD/window_status.sh $PWD active)"

tmux set mouse on
