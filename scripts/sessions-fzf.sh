#!/usr/bin/env bash

function _fzf_preview_tmux_window() {
	local data="$1"
	local id="$(<<< "$data" cut -d ' ' -f 1)"
	local name="$(<<< "$data" cut -d ' ' -f 2)"
	local panes="$(<<< "$data" cut -d ' ' -f 3)"
	local dimensions="$(<<< "$data" cut -d ' ' -f 4)"
	echo -e "\e[1m$id\e[0m $name"
	echo -e "\e[1mPANES:\e[0m $panes"
	echo -e "\e[1mDIMENSIONS:\e[0m $dimensions"
	echo -e "\e[1m---------------------------\e[0m"
}

function _fzf_preview_tmux_session() {
	local session="$@"
	local name="$(<<< "$session" cut -d ' ' -f1)"
	local attached
	if [[ 0 == $(<<< "$session" cut -d ' ' -f2) ]]; then
		attached="No"
	else
		attached='\e[32;1mYes\e[0m'
	fi

	local date="$(<<< "$session" cut -d ' '  -f3)"
	if [[ $(uname -a) =~ Linux ]] ;then
		date=$(date -d "$date" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
	else
    	date=$(date -j -f "%s" "$date" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
	fi


	local path="$(<<< "$session" cut -d ' ' -f4)"
	echo -e "\e[1mNAME:\e[0m $name"
	echo -e "\e[1mCREATION DATE:\e[0m $date"
	echo -e "\e[1mATTACHED:\e[0m $attached"
	echo -e "\e[1mSESSION WORKING DIRECTORY:\e[0m $path"

	local IFSOLD="$IFS"
	local IFS=$'\n'
	local windows=($(tmux list-windows -t "$name" -F "#{window_index} #{window_name} #{window_panes} #{window_width}x#{window_height}"))
	local IFS="$IFSOLD"
	echo -e "\e[1m----------WINDOWS----------\e[0m"
	for ((i = 0; i < ${#windows[@]}; i++)); do
		_fzf_preview_tmux_window "${windows[i]}"
	done
}

function _fzf_tmux_sessions() {
	local current_session="$1"
	local sessions="$(tmux list-session -F "#{session_name} #{session_attached} #{session_created} #{session_path}")"
	local preview_cmd="_fzf_preview_tmux_session '{}'"
	fzf  --with-nth 1 --preview "bash -c 'source \"${BASH_SOURCE[0]}\"; $preview_cmd'"\
    --header="Current: $current_session" \
    --preview-window=right:60% \
    --bind="ctrl-n:execute(tmux new-session -d -s)+reload(tmux list-sessions -F \"#{session_name}\")" \
    --bind="ctrl-n:execute(tmux new-session -d -s)+reload(tmux list-sessions -F \"#{session_name}\")" <<< "$sessions" | cut -d ' ' -f 1
}


if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	selected="$(_fzf_tmux_sessions "$1")"
	if [[ -n "$selected" ]]; then
		tmux switch-client -t "$selected"
	fi
fi
