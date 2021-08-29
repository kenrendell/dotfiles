#!/bin/sh

value=5
script_name="${0##*/}"
pipe="$XDG_RUNTIME_DIR/bar-${script_name%.*}-pipe"
mkfifo -m 600 "$pipe"

while true; do
    printf '%s\n' " $(calc.sh "$(light)")%"

    read -r mes < "$pipe"
    case $mes in
        inc) light -A "$value";;
        dec) light -U "$value";;
        exit) rm -f "$pipe"; exit;;
    esac
done
