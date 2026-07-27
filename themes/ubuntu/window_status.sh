#!/usr/bin/env bash

cd $1
source colors.sh

ZM="󰊠"
NW="󱇬"

tmux setw window-status-separator ''

window_status() {
    # Tab: dim number + name
    echo -n "#[range=user|window#{window_id} fg=$SECONDARY] #I "
    echo -n "#{?window_zoomed_flag,#[fg=$TERCIARY]$ZM ,}"
    echo -n "#[fg=$SECONDARY]#W#[norange]"
    # Close button: red rounded pill with visible ✕
    echo -n " #[range=user|kill#{window_id} fg=$RED]"
    echo -n " $LEFT_ICON"
    echo -n "#[fg=$TAGFG bg=$RED]"
    echo -n "#[fg=$RED bg=terminal norange]$RIGHT_ICON"
    # New window button after last tab
    echo -n "#{?window_end_flag,"
    echo -n " #[range=user|new fg=$PRIMARY]$LEFT_ICON"
    echo -n "#[fg=$TAGFG bg=$PRIMARY]$NW"
    echo -n "#[fg=$PRIMARY bg=terminal norange]$RIGHT_ICON"
    echo -n ",}"
}

window_active_status() {
    # Active pill opening (orange)
    echo -n " #[range=user|window#{window_id} fg=$ACTIVE_TAB_BG]$LEFT_ICON"
    # Tab content: number + name inside orange pill
    echo -n "#[fg=$ACTIVE_TAB_FG bg=$ACTIVE_TAB_BG]#I "
    echo -n "#{?window_zoomed_flag,#[fg=$PRIMARY]$ZM ,}"
    echo -n "#[fg=$ACTIVE_TAB_FG]#[bold]#W#[nobold norange]"
    # Close button: ✕ in deep aubergine on orange, inside pill
    echo -n " #[range=user|kill#{window_id} fg=$TAGFG bg=$ACTIVE_TAB_BG] #[norange]"
    # Close pill back to terminal
    echo -n "#[fg=$ACTIVE_TAB_BG bg=terminal]$RIGHT_ICON"
    # New window button after last tab
    echo -n "#{?window_end_flag,"
    echo -n " #[range=user|new fg=$PRIMARY]$LEFT_ICON"
    echo -n "#[fg=$TAGFG bg=$PRIMARY]$NW"
    echo -n "#[fg=$PRIMARY bg=terminal norange]$RIGHT_ICON"
    echo -n ",}"
}

if [[ $2 == "active" ]]; then
    echo "$(window_active_status)"
else
    echo "$(window_status)"
fi
