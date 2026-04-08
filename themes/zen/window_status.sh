#!/usr/bin/env bash

cd $1
source colors.sh

tmux setw window-status-separator ''

function get_index_format() {
	local i=("󰎡 " "󰬺 " "󰬻 " "󰬼 " "󰬽 " "󰬾 " "󰬿 " "󰭀 " "󰭁 " "󰭂 ")
	echo -n "#{?#{==:#I,0},${i[0]},}"
	echo -n "#{?#{==:#I,1},${i[1]},}"
	echo -n "#{?#{==:#I,2},${i[2]},}"
	echo -n "#{?#{==:#I,3},${i[3]},}"
	echo -n "#{?#{==:#I,4},${i[4]},}"
	echo -n "#{?#{==:#I,5},${i[5]},}"
	echo -n "#{?#{==:#I,6},${i[6]},}"
	echo -n "#{?#{==:#I,7},${i[7]},}"
	echo -n "#{?#{==:#I,8},${i[8]},}"
	echo -n "#{?#{==:#I,9},${i[9]},}"
}

function window_status() {
	if [ $1 == "minimal" ]; then
	echo -n "#[fg=$TAB_BG]"
	# echo -n "#{?window_start_flag,#[bg=terminal],#[bg=$RED]}"
	echo -n "#[range=user|window#{window_id}]"
	# echo -n " "
	# echo -n "•"
	echo -n "#{?window_zoomed_flag,#[fg=$SECONDARY],}"
	echo -n "●"
	echo -n "#[norange] "
else
	echo -n "#[range=user|window#{window_id}]"
	echo -n " "
	echo -n "$(get_index_format)"
	echo -n "#{?window_zoomed_flag, ,}"
	echo -n "#W#[norange]"
	echo -n " "
	echo -n "#[range=user|kill#{window_id}]"
	echo -n "#[fg=$RED]$LEFT_ICON#[fg=$WHITE bg=$RED]#[fg=$RED bg=$TAB_BG]"
	echo -n "#{?window_end_flag,"
	echo -n "#[bg=terminal],"
	echo -n "#[bg=$tab_bg]"
	echo -n "}#[fg=$RED bg=terminal norange]$RIGHT_ICON"
	echo -n "#{?window_end_flag,"
	echo -n " #[range=user|new]"
	echo -n "#[fg=$SECONDARY bg=terminal]$LEFT_ICON"
	echo -n "#[fg=$TAGFG bg=$SECONDARY]󱇬#[fg=$SECONDARY bg=terminal norange]$RIGHT_ICON"
	echo -n ",}"
	fi
}
function window_active_status() {
	if [ $1 == "minimal" ]; then
	echo -n "#[range=user|window#{window_id}]"
	echo -n "#[fg=$ACTIVE_TAB_BG]"
	# echo -n "#{?window_start_flag,#[bg=terminal],#[bg=$RED]}"
	echo -n "#{?window_zoomed_flag,#[fg=$PRIMARY],}"
	echo -n "●"
	echo -n "#[norange] "
else
	echo -n "#[range=user|window#{window_id}]"
	echo -n "#[fg=$ACTIVE_TAB_BG]"
	echo -n "$LEFT_ICON"
	echo -n "#[fg=$ACTIVE_TAB_FG bg=$ACTIVE_TAB_BG]"
	echo -n " "
	echo -n "$(get_index_format)"
	echo -n "#{?window_zoomed_flag, ,}"
	echo -n "#[bold]#W#[nobold norange]"
	echo -n " "
	echo -n "#[range=user|kill#{window_id}]"
	echo -n "#[fg=$RED]$LEFT_ICON#[fg=$WHITE bg=$RED]#[fg=$RED bg=$TAB_BG]"
	echo -n "#{?window_end_flag,"
	echo -n "#[bg=terminal],"
	echo -n "#[bg=$ACTIVE_TAG_BG]"
	echo -n "}#[fg=$RED bg=terminal norange]$RIGHT_ICON"

	echo -n "#{?window_end_flag,"
	echo -n " #[range=user|new]"
	echo -n "#[fg=$SECONDARY bg=terminal]$LEFT_ICON"
	echo -n "#[fg=$TAGFG bg=$SECONDARY]󱇬#[fg=$SECONDARY bg=terminal norange]$RIGHT_ICON"
	echo -n ",}"
	fi
}

if [[ $2 == "active" ]]; then
    echo "$(window_active_status)"
else
    echo "$(window_status)"
fi
