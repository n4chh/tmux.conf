#!/usr/bin/env bash

_script_path="$(dirname ${BASH_SOURCE[0]})"
source "$_script_path/../selector.sh"
mode=$(detect_terminal_bg)

BLUE=#3487ed
GREEN=#00802f
RED=#DB0000
WHITE=#ffffff

LEFT_ICON=""
RIGHT_ICON=""

SOURCE=#ff9900
AWSPRIMARY=#232f3e
SECONDARY=#146eb4
TERCIARY=#faedca
if [[ $mode == "dark" ]]; then
	PRIMARY=#f2f2f2
	PRIM_CONTRAST=#232f3e
	TAGBG=#494949
    TAGFGDIM=#909090
    TAGFG=terminal
else
	PRIMARY=#232f3e
	PRIM_CONTRAST=#f2f2f2
    TAGFG=terminal
    TAGFGDIM=#909090
    TAGBG=#d4d4d4
fi
