#!/bin/sh

# 'free -h' to display the amount of free memory and used memory in the system

script_name="${0##*/}"
_dmenu="dmenu -h $((BAR_HEIGHT + 2 * BORDER))"
attempt=3

# Keywords
c1='(1) pagecache'
c2='(2) dentries-inodes'
c3='(3) pagecache-dentries-inodes'
c4='(4) swap-space'

# Convert bytes to human readable bytes
human_bytes () {
    iec_unit='B KiB MiB GiB TiB PiB EiB'; bytes="$1"; left_digit="$bytes"; count=0

    while [ "$left_digit" -ge 1024 ]
    do
        bytes="$(printf '%s\n' "scale=3; $bytes / 1024" | bc -s)"
        left_digit="$(printf '%s' "$bytes" | cut -d '.' -f 1)"
        count="$((count + 1))"
    done

    printf '%s' "$bytes $(printf '%s' "$iec_unit" | cut -d ' ' -f $((count + 1)))"
}

cache="$(printf '%b' "$c1\\n$c2\\n$c3\\n$c4" | eval "$_dmenu -p 'Clear cache:'")"
[ "$?" = 1 ] && exit 1

case "$cache" in
    "$c1"|"$c2"|"$c3"|"$c4")
        while [ "$attempt" -gt 0 ]
        do
            # Input root password
            pass="$(eval "$_dmenu -P -p 'Root password:'")"
            [ "$?" = 1 ] && exit 1; printf '%s' "$pass" | su -l; error_0="$?"
            [ "$error_0" != 0 ] && { attempt=$((attempt - 1)); continue; }

            # Get the amount of free memory in the system before clearing cache
            if [ "$cache" = "$c4" ]; then mem_type='Swap'; else mem_type='Mem'; fi
            mem_free_old="$(free -b | grep "$mem_type" | awk '{ printf $4 }')"

            # Clear the memory
            # 'sync' will flush the file system buffer
            case "$cache" in
                "$c1") printf '%s' "$pass" | su -l -c 'sync; printf 1 > /proc/sys/vm/drop_caches' ;;
                "$c2") printf '%s' "$pass" | su -l -c 'sync; printf 2 > /proc/sys/vm/drop_caches' ;;
                "$c3") printf '%s' "$pass" | su -l -c 'sync; printf 3 > /proc/sys/vm/drop_caches' ;;
                "$c4") printf '%s' "$pass" | su -l -c 'swapoff -a && swapon -a' ;;
            esac; error_1="$?"

            # Output error when error occurs while clearing cache
            [ "$error_1" -ne 0 ] && notify-send -u critical "$script_name" "Failed with non-zero status $error_1" && exit "$error_1"

            # Get the amount of free memory in the system after clearing cache
            mem_free_new="$(free -b | grep "$mem_type" | awk '{ printf $4 }')"

            # Output the freed memory
            if [ "$mem_free_new" -gt "$mem_free_old" ]; then mem_freed="$(human_bytes $((mem_free_new - mem_free_old)))"; else mem_freed='0 B'; fi
            notify-send "$script_name" "Cleared cache: $mem_freed"; exit 0
        done

        notify-send -u critical "$script_name" "Authentication failed: $error_0"; exit "$error_0"
        ;;
    *) notify-send -u critical "$script_name" 'Invalid keyword'; exit 1 ;;
esac
