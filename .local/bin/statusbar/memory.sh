#!/bin/sh
# See 'free' documentation for more details.

export LANG=C
export LC_ALL=C

meminfo="$(cat /proc/meminfo)"

mem_total="$(printf '%s' "$meminfo" | sed -E -n 's/^MemTotal:[[:space:]]+([0-9]+).+$/\1/p')"
mem_free="$(printf '%s' "$meminfo" | sed -E -n 's/^MemFree:[[:space:]]+([0-9]+).+$/\1/p')"
buffers="$(printf '%s' "$meminfo" | sed -E -n 's/^Buffers:[[:space:]]+([0-9]+).+$/\1/p')"
cached="$(printf '%s' "$meminfo" | sed -E -n 's/^Cached:[[:space:]]+([0-9]+).+$/\1/p')"
sreclaimable="$(printf '%s' "$meminfo" | sed -E -n 's/^SReclaimable:[[:space:]]+([0-9]+).+$/\1/p')"
cache="$((cached + sreclaimable))"
mem_used="$((mem_total - mem_free - buffers - cache))"

swap_total="$(printf '%s' "$meminfo" | sed -E -n 's/^SwapTotal:[[:space:]]+([0-9]+).+$/\1/p')"
swap_free="$(printf '%s' "$meminfo" | sed -E -n 's/^SwapFree:[[:space:]]+([0-9]+).+$/\1/p')"
swap_used="$((swap_total - swap_free))"

printf 'Memory: %s / %s\n' "$(iecbyte.lua "$mem_used" KiB)" "$(iecbyte.lua "$mem_total" KiB)"
printf 'Swap: %s / %s\n' "$(iecbyte.lua "$swap_used" KiB)" "$(iecbyte.lua "$swap_total" KiB)"
