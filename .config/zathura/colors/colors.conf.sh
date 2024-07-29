#!/bin/sh
# Configure 'zathura' colors
# Dependencies: pastel

convert() { pastel format rgb "${1}" | tr -d '[:space:]'; }

cat << EOF > "${0%.*}"
# Tokyonight color theme for Zathura
# Swaps Foreground for Background to get a light version if the user prefers
#
# Tokyonight color theme
# See https://github.com/folke/tokyonight.nvim/blob/main/extras/zathura/tokyonight_night.zathurarc
#
set notification-error-bg    $(convert "${COLOR_01}")
set notification-error-fg    $(convert "${COLOR_FG}")
set notification-warning-bg  $(convert "${COLOR_03}")
set notification-warning-fg  $(convert "${COLOR_08}")
set notification-bg          $(convert "${COLOR_BG}")
set notification-fg          $(convert "${COLOR_FG}")
set completion-bg            $(convert "${COLOR_BG}")
set completion-fg            $(convert "${COLOR_07}")
set completion-group-bg      $(convert "${COLOR_BG}")
set completion-group-fg      $(convert "${COLOR_07}")
set completion-highlight-bg  $(convert "${COLOR_08}")
set completion-highlight-fg  $(convert "${COLOR_FG}")
set index-bg                 $(convert "${COLOR_BG}")
set index-fg                 $(convert "${COLOR_FG}")
set index-active-bg          $(convert "${COLOR_08}")
set index-active-fg          $(convert "${COLOR_FG}")
set inputbar-bg              $(convert "${COLOR_BG}")
set inputbar-fg              $(convert "${COLOR_FG}")
set statusbar-bg             $(convert "${COLOR_BG}")
set statusbar-fg             $(convert "${COLOR_FG}")
set highlight-color          $(convert "${COLOR_11}80")
set highlight-active-color   $(convert "${COLOR_10}80")
set default-bg               $(convert "${COLOR_BG}")
set default-fg               $(convert "${COLOR_FG}")
set render-loading-fg        $(convert "${COLOR_BG}")
set render-loading-bg        $(convert "${COLOR_FG}")
#
# Recolor mode settings
# <C-r> to switch modes
#
set recolor-lightcolor       $(convert "${COLOR_BG}")
set recolor-darkcolor        $(convert "${COLOR_FG}")
EOF
