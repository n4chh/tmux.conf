#!/usr/bin/env bash
cd $1
PANE_PATH=$2
source colors.sh

function vpn_status() {
    local vpn_status=$(ifconfig | grep -A 1 POINTOPOINT | grep 'inet ' | awk '{print $2}')
    if [ "$vpn_status" ]; then
		# echo -n " "
		echo -n "#[fg=$TAGBG]"
		echo -n "$LEFT_ICON"
		echo -n "#[fg=$PRIMARY bg=$TAGBG]"
		echo -n " "
		echo -n "#[fg=$TAGFG bold]$vpn_status"
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
    echo -n "#[fg=$PRIMARY bg=$TAGBG] "
    echo -n "#[fg=$TAGFG bg=$TAGBG bold]"
	echo -n "$pane_path"
    echo -n "#[nobold fg=$TAGBG bg=terminal]"
    echo -n "$RIGHT_ICON "
	if [ -n "$git_branch" ]; then
    	echo -n "#[fg=$PRIMARY bold] #[fg=terminal]$git_branch"
    	# Ahead / behind
    	local ahead=$(git -C "$pane_path" rev-list --count @{u}..HEAD 2>/dev/null)
    	local behind=$(git -C "$pane_path" rev-list --count HEAD..@{u} 2>/dev/null)

    	# Staged / unstaged / deleted
    	local staged=$(git -C "$pane_path" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
		local untracked=$(git -C "$pane_path" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    	local unstaged=$(git -C "$pane_path" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    	local deleted=$(git -C "$pane_path" ls-files --deleted 2>/dev/null | wc -l | tr -d ' ')

    	# Stash
    	local stash=$(git -C "$pane_path" stash list 2>/dev/null | wc -l | tr -d ' ')
    	local details=""
    	[ "$staged" -gt 0 ]   && details+="#[fg=$GREEN]+$staged "
    	[ "$untracked" -gt 0 ]   && details+="#[fg=terminal]?$untracked "
    	[ "$unstaged" -gt 0 ] && details+="#[fg=$YELLOW]~$unstaged "
    	[ "$deleted" -gt 0 ]  && details+="#[fg=$RED]-$deleted "
    	[ "$stash" -gt 0 ]    && details+="#[fg=$TAGFG]󰏗 $stash "
    	[ "$ahead" -gt 0 ]    && details+="#[fg=$BLUE]󰁝 $ahead "
    	[ "$behind" -gt 0 ]   && details+="#[fg=$RED]󰁅 $behind "
    	[ -n "$details" ] && echo -n " ${details%* }" 
	fi
}

date=$(date +"%D %T")
vpn=$(vpn_status)

# echo -n " #[fg=$SURFACE0]"

# echo -n "#[fg=$PRIMARY bg=$TAGBG]"
# echo -n "$RIGHT_ICON"
echo -n "$(git_status $PANE_PATH)"
echo -n "$vpn"
echo -n " "
echo -n "#[fg=$PRIMARY]"
echo -n "$date"

