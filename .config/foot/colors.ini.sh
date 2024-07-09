#!/bin/sh
# Configure 'foot' terminal colors

cat << EOF > "${0%.*}"
[colors]
foreground           = $COLOR_FG
background           = $COLOR_BG
selection-foreground = $COLOR_SFG
selection-background = $COLOR_SBG
urls                 = $COLOR_URL

regular0             = $COLOR_00
regular1             = $COLOR_01
regular2             = $COLOR_02
regular3             = $COLOR_03
regular4             = $COLOR_04
regular5             = $COLOR_05
regular6             = $COLOR_06
regular7             = $COLOR_07

bright0              = $COLOR_08
bright1              = $COLOR_09
bright2              = $COLOR_10
bright3              = $COLOR_11
bright4              = $COLOR_12
bright5              = $COLOR_13
bright6              = $COLOR_14
bright7              = $COLOR_15

16                   = $COLOR_16
17                   = $COLOR_17
EOF
