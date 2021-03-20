#!/bin/sh

scale=4

hex2rgb() {
    printf '%d %d %d\n' \
        "0x$(printf '%s' "$1" | cut -c 2-3)" \
        "0x$(printf '%s' "$1" | cut -c 4-5)" \
        "0x$(printf '%s' "$1" | cut -c 6-7)"
}

rgb2hex() {
    printf '#%02X%02X%02X' \
        "$(printf '%s' "$1" | cut -d ' ' -f 1)" \
        "$(printf '%s' "$1" | cut -d ' ' -f 2)" \
        "$(printf '%s' "$1" | cut -d ' ' -f 3)"
}

rgb2hsl() {
    r="$(printf '%s' "$1" | cut -d ' ' -f 1)"
    g="$(printf '%s' "$1" | cut -d ' ' -f 2)"
    b="$(printf '%s' "$1" | cut -d ' ' -f 3)"

    sortval="$(printf '%s\n%s\n%s\n' "$r" "$g" "$b" | sort -n)"
    min="$(printf '%s' "$sortval" | sed -n '1p')"
    max="$(printf '%s' "$sortval" | sed -n '$p')"

    h=0; s=0; l="$(calc.sh "($min + $max) / 510" $scale)"
    d="$((max - min))"

    if [ "$d" -gt 0 ]; then
        if [ "$(printf 'o=(%s <= 0.5); o\n' "$l" | bc -s)" -eq 1 ]; then
            s="$(calc.sh "$d / ($max + $min)" $scale)"
        else
            s="$(calc.sh "$d / (510 - $max - $min)" $scale)"
        fi

        case "$max" in
            "$r") h="$(calc.sh "($g - $b) / $d" $scale)" ;;
            "$g") h="$(calc.sh "2 + ($b - $r) / $d" $scale)" ;;
            "$b") h="$(calc.sh "4 + ($r - $g) / $d" $scale)" ;;
        esac

        [ "$(printf 'o=(%s < 0); o\n' "$h" | bc -s)" -eq 1 ] && h="$(calc.sh "$h + 6" $scale)"
    fi

    printf '%s %s %s\n' "$h" "$s" "$l"
}

hsl2rgb() {
    h="$(printf '%s' "$1" | cut -d ' ' -f 1)"
    s="$(printf '%s' "$1" | cut -d ' ' -f 2)"
    l="$(printf '%s' "$1" | cut -d ' ' -f 3)"

    if [ "$(printf 'o=(%s < 0.5); o\n' "$l" | bc -s)" -eq 1 ]; then
        min="$(calc.sh "255 * $l * (1 - $s)")"
        max="$(calc.sh "255 * $l * (1 + $s)")"
    else
        min="$(calc.sh "255 * ($l - (1 - $l) * $s)")"
        max="$(calc.sh "255 * ($l + (1 - $l) * $s)")"
    fi

    if [ "$(printf 'o=(%s < 1); o\n' "$h" | bc -s)" -eq 1 ]; then
        r="$max"
        g="$(calc.sh "$h * ($max - $min) + $min")"
        b="$min"
    elif [ "$(printf 'o=(%s < 2); o\n' "$h" | bc -s)" -eq 1 ]; then
        r="$(calc.sh "(2 - $h) * ($max - $min) + $min")"
        g="$max"
        b="$min"
    elif [ "$(printf 'o=(%s < 3); o\n' "$h" | bc -s)" -eq 1 ]; then
        r="$min"
        g="$max"
        b="$(calc.sh "($h - 2) * ($max - $min) + $min")"
    elif [ "$(printf 'o=(%s < 4); o\n' "$h" | bc -s)" -eq 1 ]; then
        r="$min"
        g="$(calc.sh "(4 - $h) * ($max - $min) + $min")"
        b="$max"
    elif [ "$(printf 'o=(%s < 5); o\n' "$h" | bc -s)" -eq 1 ]; then
        r="$(calc.sh "($h - 4) * ($max - $min) + $min")"
        g="$min"
        b="$max"
    else
        r="$max"
        g="$min"
        b="$(calc.sh "(6 - $h) * ($max - $min) + $min")"
    fi

    printf '%s %s %s\n' "$r" "$g" "$b"
}

adjust_color() {
    hsl="$(rgb2hsl "$(hex2rgb "$1")")"
    s="$(calc.sh "$(printf '%s' "$hsl" | cut -d ' ' -f 2) + ($3 / 100)" $scale)"
    l="$(calc.sh "$(printf '%s' "$hsl" | cut -d ' ' -f 3) + ($4 / 100)" $scale)"

    if [ "$(printf 's=%s; l=%s; a=((s >= 0) == (s <= 1)); b=((l >= 0) == (l <= 1)); o=(a == b); if ((o == 1) == (a == 0)) o=0; o\n' "$s" "$l" | bc -s)" -eq 0 ]; then
        printf '%s' "$1"
    else
        h="$(calc.sh "$(printf '%s' "$hsl" | cut -d ' ' -f 1) + ($2 / 60)" $scale)"
        while [ "$(printf 'h=%s; o=((h >= 0) == (h <= 6)); o\n' "$h" | bc -s)" -eq 0 ]; do
            if [ "$(printf 'o=(%s < 0); o\n' "$h" | bc -s)" -eq 1 ]; then
                h="$(calc.sh "$h + 6" $scale)"
            else h="$(calc.sh "$h - 6" $scale)"; fi
        done

        printf '%s' "$(rgb2hex "$(hsl2rgb "$h $s $l")")"
    fi
}
