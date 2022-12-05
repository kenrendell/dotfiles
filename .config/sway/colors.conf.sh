#!/bin/sh
# Configure 'sway' window manager colors

cat << EOF > "${0%.*}"
set \$COLOR_0  '#$COLOR_0'
set \$COLOR_1  '#$COLOR_1'
set \$COLOR_2  '#$COLOR_2'
set \$COLOR_3  '#$COLOR_3'
set \$COLOR_4  '#$COLOR_4'
set \$COLOR_5  '#$COLOR_5'
set \$COLOR_6  '#$COLOR_6'
set \$COLOR_7  '#$COLOR_7'
set \$COLOR_8  '#$COLOR_8'
set \$COLOR_9  '#$COLOR_9'
set \$COLOR_10 '#$COLOR_10'
set \$COLOR_11 '#$COLOR_11'
set \$COLOR_12 '#$COLOR_12'
set \$COLOR_13 '#$COLOR_13'
set \$COLOR_14 '#$COLOR_14'
set \$COLOR_15 '#$COLOR_15'
EOF
