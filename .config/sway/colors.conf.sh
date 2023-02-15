#!/bin/sh
# Configure 'sway' window manager colors

cat << EOF > "${0%.*}"
set \$COLOR_00 '#$COLOR_00'
set \$COLOR_01 '#$COLOR_01'
set \$COLOR_02 '#$COLOR_02'
set \$COLOR_03 '#$COLOR_03'
set \$COLOR_04 '#$COLOR_04'
set \$COLOR_05 '#$COLOR_05'
set \$COLOR_06 '#$COLOR_06'
set \$COLOR_07 '#$COLOR_07'
set \$COLOR_08 '#$COLOR_08'
set \$COLOR_09 '#$COLOR_09'
set \$COLOR_10 '#$COLOR_10'
set \$COLOR_11 '#$COLOR_11'
set \$COLOR_12 '#$COLOR_12'
set \$COLOR_13 '#$COLOR_13'
set \$COLOR_14 '#$COLOR_14'
set \$COLOR_15 '#$COLOR_15'
set \$COLOR_FG '#$COLOR_FG'
set \$COLOR_BG '#$COLOR_BG'
EOF
