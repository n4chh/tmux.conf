#!/usr/bin/env bash

cd $1
source colors.sh

tmux setw -g window-status-separator ''

function get_index_format() {
	# local i=("󰎡 " "󰬺 " "󰬻 " "󰬼 " "󰬽 " "󰬾 " "󰬿 " "󰭀 " "󰭁 " "󰭂 ")
	local i=("0 " "󰲠 " "󰲢 " "󰲤 " "󰲦 " "󰲨 " "󰲪 " "󰲬 " "󰲮 " "󰲰 ")
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
	echo -n "#{?#{e|>:#I,9},#I,}"
}

function window_status() {
	local tab_bg=terminal
	echo -n "#[range=window|#window_id]"
	echo -n "#[fg=$TAGFG]"
	# echo -n " "
	# echo -n "$(get_index_format)"
	# echo -n "#{?window_zoomed_flag, ,}"
	echo -n "#{?window_zoomed_flag,#[fg=$BRILLIANT_YELLOW],}"
	echo -n "#{?window_activity_flag,#[fg=$CYAN],}"
	echo -n "#{?window_bell_flag,#[fg=$ACCENT],}"
	echo -n "$(get_index_format)"
	# echo -n "●"
	# echo -n ""
	# echo -n "•"
	echo -n "#[norange] "

}
function window_active_status() {
	local active_tab_bg=$PRIMARY
	local tab_bg=terminal
	echo -n "#[range=window|#window_id]"
	echo -n "#[fg=$active_tab_bg]"
	echo -n "#{?window_zoomed_flag,#[fg=$BRILLIANT_YELLOW],}"
	# NOTE: current window highlight on bell or activity is no supported by tmux
	# echo -n ""
	# echo -n "●"
	echo -n "$(get_index_format)"
	# echo -n "•"
	echo -n "#[norange] "
}

if [[ $2 == "active" ]]; then
    echo "$(window_active_status)"
else
    echo "$(window_status)"
fi
