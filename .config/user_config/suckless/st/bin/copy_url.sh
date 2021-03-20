#!/bin/sh

urlregex="(((http|https)://|www\\.)[a-zA-Z0-9.]*[:]?[a-zA-Z0-9./@$&%?$\#=_~-]*)|((magnet:\\?xt=urn:btih:)[a-zA-Z0-9]*)"
urls="$(sed 's/.*│//g' | tr -d '\n' | grep -aEo "$urlregex" | uniq | sed 's/^www./http:\/\/www\./g')"

[ -z "$urls" ] && exit
printf '%b' "$urls" | dmenu $(dmenu_center.sh 600 12) -p 'Copy URL:' | xclip -r -selection clipboard
