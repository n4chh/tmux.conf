#!/usr/bin/env bash
cd $1
PANE_PATH=$2
source colors.sh

ST="󰏗"
AH="󰁝"
BH="󰁅"

vpn_status() {
    local vpn_ip=$(ifconfig 2>/dev/null | grep -A 1 POINTOPOINT | grep 'inet ' | awk '{print $2}')
    if [ -n "$vpn_ip" ]; then
        echo -n " "
        echo -n "#[fg=$TERCIARY]$LEFT_ICON"
        echo -n "#[fg=$TAGFG bg=$TERCIARY] vpn "
        echo -n "#[bold]$vpn_ip"
        echo -n "#[nobold fg=$TERCIARY bg=terminal]$RIGHT_ICON"
    fi
}

git_status() {
    local pane_path="$1"
    local git_branch=$(git -C "$pane_path" rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Path pill
    echo -n " "
    echo -n "#[fg=$TAGBG]$LEFT_ICON"
    echo -n "#[fg=$PRIMARY bg=$TAGBG]$ICON_FOLDER "
    echo -n "#[fg=$TAGFG bg=$TAGBG bold]$pane_path"
    echo -n "#[nobold fg=$TAGBG bg=terminal]$RIGHT_ICON"

    if [ -n "$git_branch" ]; then
        local ahead=$(git -C "$pane_path" rev-list --count @{u}..HEAD 2>/dev/null)
        local behind=$(git -C "$pane_path" rev-list --count HEAD..@{u} 2>/dev/null)
        local staged=$(git -C "$pane_path" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        local untracked=$(git -C "$pane_path" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
        local unstaged=$(git -C "$pane_path" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        local deleted=$(git -C "$pane_path" ls-files --deleted 2>/dev/null | wc -l | tr -d ' ')
        local stash=$(git -C "$pane_path" stash list 2>/dev/null | wc -l | tr -d ' ')

        echo -n " #[fg=$SOURCE bold range=user|git]$ICON_BRANCH #[nobold fg=terminal]$git_branch"

        local details=""
        [ "$staged"    -gt 0 ] && details+="#[fg=$GREEN]+$staged "
        [ "$untracked" -gt 0 ] && details+="#[fg=terminal]?$untracked "
        [ "$unstaged"  -gt 0 ] && details+="#[fg=$YELLOW]~$unstaged "
        [ "$deleted"   -gt 0 ] && details+="#[fg=$RED]-$deleted "
        [ "$stash"     -gt 0 ] && details+="#[fg=$TAGFGDIM]$ST $stash "
        [ "$ahead"     -gt 0 ] && details+="#[fg=$BLUE]$AH $ahead "
        [ "$behind"    -gt 0 ] && details+="#[fg=$RED]$BH $behind "
        [ -n "$details" ] && echo -n " ${details%* }"
        echo -n "#[norange]"
    fi
}

date_str=$(date +"%D %T")

echo -n "$(git_status "$PANE_PATH")"
echo -n "$(vpn_status)"
echo -n " "
echo -n "#[fg=$TAGBG]$LEFT_ICON"
echo -n "#[fg=$PRIMARY bg=$TAGBG]$ICON_CLOCK"
echo -n "#[fg=$TAGFG bg=$TAGBG] $date_str"
echo -n "#[fg=$TAGBG bg=terminal]$RIGHT_ICON"
echo -n " "
