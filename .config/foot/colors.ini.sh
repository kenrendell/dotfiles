#!/bin/sh
# Configure 'foot' terminal colors

cat << EOF > "${0%.*}"
[colors]
regular0   = $COLOR_0
regular1   = $COLOR_1
regular2   = $COLOR_2
regular3   = $COLOR_3
regular4   = $COLOR_4
regular5   = $COLOR_5
regular6   = $COLOR_6
regular7   = $COLOR_7
bright0    = $COLOR_8
bright1    = $COLOR_9
bright2    = $COLOR_10
bright3    = $COLOR_11
bright4    = $COLOR_12
bright5    = $COLOR_13
bright6    = $COLOR_14
bright7    = $COLOR_15
foreground = $COLOR_7
background = $COLOR_0

[cursor]
color      = $COLOR_0 $COLOR_7
EOF
