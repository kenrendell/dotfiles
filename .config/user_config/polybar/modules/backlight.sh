#!/bin/sh

inc=5; dec=5
signal="$XDG_RUNTIME_DIR/$$-signal"

trap "printf ''" USR1

while true; do
    if [ -f "$signal" ]; then case "$(cat "$signal")" in
        4) light -A "$inc" ;;
        5) light -U "$dec" ;;
    esac; rm "$signal"; fi

    output="BL $(calc.sh "$(light)")%"
    cmd="kill -USR1 $$"
    printf '%s\n' "%{A4:printf 4 > $signal; $cmd:}%{A5:printf 5 > $signal; $cmd:}$output%{A A}"
    read -r REPLY
done
