#!/usr/bin/env bash
cd $1
source ./colors.sh

echo -n "#[range=left fg=$SOURCE ]"
echo -n "#{?#{==:#{pane_mode},copy-mode},[C],}"
echo -n "#{?#{pane_mode},,[N]}"
echo -n " #[fg=$PRIMARY nobold ]#W #[fg=terminal]at #[fg=$FG bold]#S"
echo -n " #[fg=$TERCIARY nobold]❯#[fg=terminal norange] "
