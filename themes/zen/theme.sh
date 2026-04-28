#!/usr/bin/env bash
tmux set status-justify center 


script_path="$HOME/.config/tmux/scripts"
tmux bind-key -Troot MouseDown1Status run-shell "$script_path/status-click.sh #{mouse_status_range} #{window_id}"

command="display-popup -T '🗄️Session selector' -E '$script_path/sessions-fzf.sh'"
tmux bind-key -T root MouseDown1StatusLeft "$command"
tmux bind-key -Troot F1 "$command"
tmux bind-key -Troot F12 run-shell "$script_path/status-click.sh git"

tmux set status 2
tmux set status-right-length 200
tmux set status-left-length 200
tmux set status-interval 1
# tmux set status-left '#('"$PWD"'/left_status.sh '"$PWD"')'
# tmux set status-right '#('"$PWD"'/right_status.sh '"$PWD"' #{pane_current_path})'
tmux set 'status-format[0]' "#[align=left]#{W:#($PWD/window_status.sh $PWD),#($PWD/window_status.sh $PWD active)}"
tmux set 'status-format[1]' '#[align=left]#('"$PWD"'/left_status.sh '"$PWD"')#[align=right]#('"$PWD"'/right_status.sh '"$PWD"' #{pane_current_path})'
tmux set window-status-format "#($PWD/window_status.sh $PWD)"
tmux set window-status-current-format "#($PWD/window_status.sh $PWD active)"

# tmux set window-status-format "#($PWD/window_status.sh $PWD)"
# tmux set window-status-current-format "#($PWD/window_status.sh $PWD active)"
# tmux set window-status-current-format "#{E:window-status-format}"

tmux set mouse on

source $PWD/colors.sh

tmux set status-position top
tmux set pane-border-status  off
tmux set pane-border-lines single
tmux set pane-border-format "#[fg=terminal]"
tmux set pane-border-format "#[fg=terminal]"
tmux set pane-border-style 'fg=terminal'
tmux set pane-active-border-style "fg=$SOURCE"
tmux set status-style "bg=terminal fg=$SOURCE"
# tmux set status-position bottom
