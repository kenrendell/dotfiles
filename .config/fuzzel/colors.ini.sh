#!/bin/sh
# Configure 'fuzzel' launcher colors

cat << EOF > "${0%.*}"
[colors]
background      = ${COLOR_BG}ff
text            = ${COLOR_FG}ff
match           = ${COLOR_03}ff
selection       = ${COLOR_SBG}ff
selection-text  = ${COLOR_SFG}ff
selection-match = ${COLOR_14}ff
border          = ${COLOR_12}ff
EOF
