#!/usr/bin/env bash

_script_path="$(dirname ${BASH_SOURCE[0]})"
source "$_script_path/../selector.sh"
mode=$(detect_terminal_bg)

BLUE=#3487ed
RED=#DB0000
WHITE=#ffffff

LEFT_ICON=""
RIGHT_ICON=""

BLACK="#1d1d1f"
WHITE="#FFFFFF"
MINTGREEN="#98FF98"
CORAL="#FF6F61"

GREEN=#73D216
YELLOW=#FCF8b3
RED="#D9534F"

GREY="#DDDAEC"
ACCENT="#6E56AF"
PRIMARY=$ACCENT
if [[ $mode == dark ]]; then
	TAGBG="$BLACK"
    TAGFG="$GREY"
else
    TAGFG=terminal
    TAGBG="$GREY"
fi
