#!/usr/bin/env bash
cd $1
source ./colors.sh

echo -n "#[range=left]"
echo -n "#[fg=$SOURCE bold]$UBUNTU_LOGO "
echo -n "#[fg=$SECONDARY nobold]"
echo -n "#{?#{==:#{pane_mode},copy-mode},[C],}"
echo -n "#{?#{pane_mode},,[N]}"
echo -n " #[fg=$PRIMARY]#W #[fg=$SECONDARY]at #[fg=$FG bold]#S"
echo -n " #[fg=$SOURCE nobold]❯#[fg=terminal norange] "
