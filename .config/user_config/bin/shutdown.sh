#!/bin/sh

script_name="${0##*/}"
_dmenu="dmenu -h $((BAR_HEIGHT + 2 * BORDER))"

# Keywords
p1='lock'
p2='exit'
p3='poweroff'
p4='reboot'
p5='suspend'
p6='hibernate'

power="$(printf '%b' "$p1\\n$p2\\n$p3\\n$p4\\n$p5\\n$p6" | eval "$_dmenu -p 'Shutdown:'")"
[ "$?" = 1 ] && exit 1

case "$power" in
    "$p1"|"$p2"|"$p3"|"$p4"|"$p5"|"$p6")
        ans="$(printf '%b' 'yes\nno' | eval "$_dmenu -p 'Continue?'")"
        [ "$?" = 1 ] && exit 1

        if [ "$ans" = 'yes' ]; then
            case "$power" in
                "$p1") slock dunstctl set-paused true && dunstctl set-paused false ;;
                "$p2") bspc quit ;;
                "$p3") systemctl poweroff -i ;;
                "$p4") systemctl reboot ;;
                "$p5") slock sh -c 'dunstctl set-paused true && systemctl suspend' && dunstctl set-paused false ;;
                "$p6") slock sh -c 'dunstctl set-paused true && systemctl hibernate' && dunstctl set-paused false ;;
            esac; error="$?"

            [ "$error" -ne 0 ] && notify-send -u critical "$script_name" "Failed with non-zero status $error" && exit "$error"
            exit 0
        else exit 0; fi
        ;;
    *) notify-send -u critical "$script_name" 'Invalid keyword'; exit 1 ;;
esac
