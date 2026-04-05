#!/usr/bin/env bash
cd $1
PANE_PATH=$2
source $PWD/colors.sh
# LEFT_ICON=""
# RIGHT_ICON=""

function vpn_status() {
    local vpn_status=$(ifconfig | grep -A 1 POINTOPOINT | grep 'inet ' | awk '{print $2}')
    if [ "$vpn_status" ]; then
		
		# echo -n "#[fg=$TEXT bg=$SURFACE0]"
		# echo -n " "
		# echo -n "#[fg=$SUBTEXT0 bg=$SURFACE0] Disconnected"
    # else
		echo -n " "
		echo -n "#[fg=$TAGBG ]"
		echo -n "$LEFT_ICON"
		echo -n "#[fg=$YELLOW bg=$TAGBG]"
		echo -n " "
		echo -n "#[fg=$GREEN bold] $vpn_status"
		echo -n "#[nobold fg=$TAGBG bg=terminal]"
		echo -n "$RIGHT_ICON"
    fi
}

git_status() {
    local pane_path="$1"
    local git_branch=$(git -C "$pane_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
    
    # Build the detail string

    echo -n " "
    echo -n "#[fg=$TAGBG]"
    echo -n "$LEFT_ICON"
    echo -n "#[fg=$TAGFG bg=$TAGBG]"
    echo -n "#[fg=$ACCENT bg=$TAGBG] "
    echo -n "#[fg=$TAGFG bg=$TAGBG bold]"
	echo -n "$pane_path"
	if [ -n "$git_branch" ]; then
    	echo -n "  #[fg=$TAGFG]$git_branch"
    	# Ahead / behind
    	local ahead=$(git -C "$pane_path" rev-list --count @{u}..HEAD 2>/dev/null)
    	local behind=$(git -C "$pane_path" rev-list --count HEAD..@{u} 2>/dev/null)

    	# Staged / unstaged / deleted
    	local staged=$(git -C "$pane_path" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    	local unstaged=$(git -C "$pane_path" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    	local deleted=$(git -C "$pane_path" ls-files --deleted 2>/dev/null | wc -l | tr -d ' ')

    	# Stash
    	local stash=$(git -C "$pane_path" stash list 2>/dev/null | wc -l | tr -d ' ')
    	local details=""
    	[ "$staged" -gt 0 ]   && details+="#[fg=$GREEN]+$staged "
    	[ "$unstaged" -gt 0 ] && details+="#[fg=$YELLOW]~$unstaged "
    	[ "$deleted" -gt 0 ]  && details+="#[fg=$RED]-$deleted "
    	[ "$stash" -gt 0 ]    && details+="#[fg=$SUBTEXT0]󰏗 $stash "
    	[ "$ahead" -gt 0 ]    && details+="#[fg=$BLUE]󰁝 $ahead "
    	[ "$behind" -gt 0 ]   && details+="#[fg=$RED]󰁅 $behind "
    	[ -n "$details" ] && echo -n " ${details%* }" 
	fi
    echo -n "#[nobold fg=$TAGBG bg=terminal]"
    echo -n "$RIGHT_ICON "
}

date=$(date +"%D %T")
vpn=$(vpn_status)


echo -n "#[fg=terminal]"
echo -n "$(git_status "$PANE_PATH")"
echo -n " "
echo -n "#[fg=$TAGBG]$LEFT_ICON"
echo -n "#[bg=$TAGBG fg=$TAGFG]#W"
echo -n "#[bg=terminal fg=$TAGBG]$RIGHT_ICON#[fg=terminal]"
echo -n " at #[bold]#S"
# echo -n "$vpn"
echo -n " "
echo -n "#[fg=$PRIMARY]"
echo -n "${date}"
