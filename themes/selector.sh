#!/usr/bin/env bash

BASE_PATH="$HOME/.config/tmux/themes"
DEFAULT_THEME="$BASE_PATH/zen"

get_theme() {
	local theme="$1"

	if [[ -z "$theme" ]]; then
		echo "$DEFAULT_THEME"
		return
	fi

	if ! [[ -d "$BASE_PATH/$theme" ]]; then
		echo "$DEFAULT_THEME"
		return
	fi

	theme="$BASE_PATH/$theme"
	if [[ -f "$theme/theme.sh" ]]; then
		echo "$theme"
	else
		echo "$DEFAULT_THEME"
	fi

}

change_theme() {
	local script_path="$BASE_PATH/selector.sh"
	local new_theme="$1"	
	if [[ -z $new_theme ]]; then
		return 1
	fi
	shopt -s nocasematch 
	if [[ $(uname -a) =~ Linux ]]; then
		sed -i 's/\(DEFAULT_THEME="$BASE_PATH\/\).*"/\1'"$new_theme"'"/g' "$script_path"
	else 
		sed -i '' 's/\(DEFAULT_THEME="$BASE_PATH\/\).*"/\1'"$new_theme"'"/g' "$script_path"
	fi
	shopt -u nocasematch 
}

source_theme() {
	local theme="$(get_theme $1)"
	cd "$theme"
	tmux set -u status
	tmux set -u 'status-format'
	tmux set 'status-format[0]' "#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{E:window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?loop_last_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{E:window-status-current-style},default},#{E:window-status-current-style},#{E:window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{E:window-status-last-style},default}}, #{E:window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{E:window-status-bell-style},default}}, #{E:window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{E:window-status-activity-style},default}}, #{E:window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?loop_last_flag,,#{window-status-separator}}}#[nolist align=right range=right #{E:status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
	# tmux set -u 'status-format[1]'
	# Reset status formats
	source "$theme/theme.sh"
}



fzf_theme_selector() {
	local oifs=$IFS
	IFS=$' '
	local themes=($(/bin/ls -d ~/.config/tmux/themes/*/ | xargs -n 1 basename))
	IFS="$oifs"

    echo "$themes" | fzf --prompt="Select session: " \
            --header="Current: $DEFAULT_THEME" \
			--preview="source $BASE_PATH/selector.sh; source_theme {}" \
            --preview-window=right:60% \
			--bind="esc:execute(source $BASE_PATH/selector.sh; source_theme)+abort" \
			--bind="enter:execute(source $BASE_PATH/selector.sh; source_theme {}; change_theme {})+accept"
}

setup_tmux_hooks() {
	local themes_folder_path="$(dirname "${BASH_SOURCE[0]}")"
	tmux set -g allow-passthrough
	tmux set-hook -g client-light-theme "run-shell 'echo light > $themes_folder_path/mode.txt'"
	tmux set-hook -g client-dark-theme "run-shell 'echo dark > $themes_folder_path/mode.txt'"
}

detect_terminal_bg() {
	local tmux_version=$(tmux -V | cut -d ' ' -f 2)
	local themes_folder_path="$(dirname "${BASH_SOURCE[0]}")"

	if [[ "$tmux_version" =~ 3\.6 ]] && [[ -f "$themes_folder_path/mode.txt" ]]; then
		cat "$themes_folder_path/mode.txt"
	else
		# first try to get actual background using osc, if not we check local system priority
		if [[ $TERM =~ xterm ]]; then
			# Get terminal bg color using Xterm OSC (Operative System Commands)
			# Script from: https://stackoverflow.com/questions/2507337/how-to-determine-a-terminals-background-color
			oldstty=$(stty -g)
			# What to query?
			# 11: text background
			# Ps=${1:-11}
			local Ps=11
			stty raw -echo min 0 time 0
			# stty raw -echo min 0 time 1
			printf "\033]$Ps;?\033\\"
			# xterm needs the sleep (or "time 1", but that is 1/10th second).
			sleep 0.00000001
			local answer
			read -r answer
			# echo $answer | cat -A
			local result=${answer#*;}
			stty $oldstty

			if [[ "$result" =~ rgb:([0-9a-f]+)/([0-9a-f]+)/([0-9a-f]+) ]]; then
			    r=$((0x${BASH_REMATCH[1]:0:2}))
			    g=$((0x${BASH_REMATCH[2]:0:2}))
			    b=$((0x${BASH_REMATCH[3]:0:2}))
			    brightness=$(((r + g + b) / 3))

			    if [[ $brightness -lt 128 ]];then
					colorscheme="dark"
				else
					colorscheme="light"
				fi
			fi
		fi

		shopt -s nocasematch
		if [[ -z colorscheme ]]; then
			if [[ "$(uname -a)" =~ linux ]]; then
				colorscheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | grep -oiE 'dark|light')
			else
				colorscheme=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo Light)
			fi
		fi
		shopt -u nocasematch
		echo $colorscheme | awk '{print tolower($0)}'
	fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	command="display-popup -T '🎨Theme selector' -E 'source ~/.config/tmux/themes/selector.sh; fzf_theme_selector'"
	tmux bind-key -Troot F3 "$command"
	setup_tmux_hooks
	source_theme 
fi
