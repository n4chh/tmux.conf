#!/usr/bin/env bash
tmux set status-justify left

tmux set status on
tmux set status-right-length 200
tmux set status-left-length 40
tmux set status-interval 1
tmux set status-left "#($PWD/left_status.sh $PWD)"
tmux set status-right "#($PWD/right_status.sh $PWD)"
tmux set base-index 1
tmux set pane-base-index 1



script_path="$HOME/.config/tmux/scripts"
tmux bind-key -Troot MouseDown1Status run-shell "$script_path/status-click.sh #{mouse_status_range} #{window_id}"


command="display-popup -T '🗄️Session selector' -E '$script_path/sessions-fzf.sh #{session_name}'"
tmux bind-key -T root MouseDown1StatusLeft "$command"
tmux bind-key -Troot F1 "$command"


tmux set window-status-format "#($PWD/window_status.sh $PWD)"
tmux set window-status-current-format "#($PWD/window_status.sh $PWD active)"
tmux set window-status-activity-style "default"
tmux set window-status-bell-style "default"
tmux set monitor-activity on
tmux set visual-bell off
tmux set visual-activity off
# tmux set window-status-current-format "#{E:window-status-format}"

tmux set mouse on

# Direct parent must export function if not it will be losed
source $PWD/colors.sh

tmux set pane-border-lines heavy
tmux set status-position top
tmux set pane-border-status off
tmux set pane-border-format "#[fg=terminal]"
tmux set pane-border-format "#[fg=terminal]"
tmux set pane-border-style 'fg=terminal'
tmux set pane-active-border-style "fg=$ACCENT"
tmux set status-style "bg=terminal fg=$ACCENT"
# tmux set status-position bottom
