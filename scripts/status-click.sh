#!/usr/bin/env bash

mouse_status_range="$1"
window_id="$2"
a=$3
case "$mouse_status_range" in
	window)
		tmux select-window -t "$window_id"
	;;
	# user defined window status
	# This is added due to a weird issue we have in some versions of tmux and with some plugins that have more
	# than 1 line for status lines
	window*)
		tmux select-window -t "${mouse_status_range#window}"
	;;
	kill*)
		tmux kill-window -t "${mouse_status_range#kill}"
	;;
	new)
		tmux new-window
	;;
	git)
		local_path=$(tmux display-message -p '#{pane_current_path}')
		tmux display-popup -T " git: $local_path" -w 90% -h 90% -EE "lazygit -p '$local_path'"
	;;
	*)
		echo "[$(date)] - mouse_status_range: $mouse_status_range window_id: $window_id" >> ~/.local/share/tmux/scripts.log
	;;
esac
status=$?
if [[ $status -ne 0 ]]; then
	[[ -d ~/.local/share/tmux ]] || mkdir ~/.local/share/tmux
	msg="Check logs at \e[1m~/.local/share/tmux"
	tmux display-popup -T "Error code: $status" -x P -y P -h 4 -w 40 -EE "echo -en '$msg' ; sleep 1.5"
	echo "[$(date)] - mouse_status_range: $mouse_status_range window_id: $window_id" >> ~/.local/share/tmux/scripts.log
fi

