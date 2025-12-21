#!/usr/bin/env bash

_utils_path="$HOME/.config/tmux/themes/utils.sh"
source $_utils_path
mode=$(detect_mode 2>&1)
BLUE=#3487ed
RED=#DB0000
WHITE=#ffffff

LEFT_ICON=""
RIGHT_ICON=""

BLACK="#1d1d1f"
WHITE="#FFFFFF"

ILUMINATED_NAVY="#4F505C"
BRILLIANT_YELLOW="#FFD497"
GLOWING_CORAL="#EDA09C"
LUMINOUS_ORCHID="#D1B6CB"
CYAN="#99b8e5"

ACCENT="$GLOWING_CORAL"
PRIMARY=$LUMINOUS_ORCHID
shopt -s nocasematch
if [[ $mode =~ dark ]]; then
	PRIMARY=$LUMINOUS_ORCHID
	TAGBG="$BRILLIANT_YELLOW"
    TAGFG="$ILUMINATED_NAVY"
else
	PRIMARY=$ILUMINATED_NAVY
    TAGFG=$LUMINOUS_ORCHID
    TAGBG="$PRIMARY"
fi
shopt -u nocasematch
