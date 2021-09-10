#!/bin/sh

str="$1"
url=

dec_to_bin() {
    while [ "${dec="$1"}" -gt 0 ]; do
        bin="$((dec % 2))$bin"
        dec="$((dec / 2))"
    done
    printf '%d' "${bin:-0}"
    unset dec bin
}

bin_to_dec() {
    bin="$1"; dec=0; n=1;
    while true; do
        nbin="${bin%?}"
        bit="${bin#"$nbin"}"
        [ -n "$bit" ] || break

        [ "$bit" -eq 1 ] && \
            dec="$((dec + n))"

        bin="$nbin"
        n="$((n * 2))"
    done
    printf '%d' "$dec"
    unset bin dec nbin bit n
}

char_to_utf8() {
    dec="$(printf '%d' "'$1")"

    if [ "$dec" -lt 128 ]; then
        printf '%%%02X' "$dec"

    elif [ "$dec" -lt 2048 ]; then
        bin="$(printf '%011d' "$(dec_to_bin "$dec")")"
        b0="${bin#?????}"
        bin="110${bin%"$nbin"}10${b0}"

        printf '%%%04X' "$(bin_to_dec "$bin")"
        unset b0

    elif [ "$dec" -lt 65536 ]; then
        bin="$(printf '%016d' "$(dec_to_bin "$dec")")"
        b0="${bin#??????????}"
        b1="${bin%"$b0"}"
        b2="${b1#????}"
        bin="1110${bin%"$b2$b0"}10${b2}10${b0}"

        printf '%%%06X' "$(bin_to_dec "$bin")"
        unset b0 b1 b2

    else
        bin="$(printf '%021d' "$(dec_to_bin "$dec")")"
        b0="${bin#???????????????}"
        b1="${bin%"$b0"}"
        b2="${b1#?????????}"
        b3="${bin%"$b2$b0"}"
        b4="${b3#???}"
        bin="11110${bin%"$b4$b2$b0"}10${b4}10${b2}10${b0}"

        printf '%%%08X' "$(bin_to_dec "$bin")"
        unset b0 b1 b2 b3 b4
    fi
    unset dec bin
}

while true; do
    nstr="${str#?}"
    char="${str%"$nstr"}"
    [ -n "$char" ] || break

    case "$char" in
        [a-zA-Z0-9/_.~-]) url="${url}${char}";;
        *) url="${url}$(printf '%%%02X' "'${char}")";;
    esac

    str="$nstr"
done

printf '%s\n' "$url"
