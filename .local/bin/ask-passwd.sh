#!/bin/sh
# Ask for password
# Dependencies: fuzzel

# Usage: ask-passwd.sh <prompt>
[ "$#" -eq 1 ] || { printf 'Usage: ask-passwd.sh <prompt>\n' 1>&2; exit 1; }

prompt="$1"
while [ "${prompt%[[:space:]]}" != "$prompt" ]
do prompt="${prompt%[[:space:]]}"; done

password="$(printf '' | fuzzel --dmenu --lines=0 --password= --prompt="${prompt} ")\\n"
printf '%b' "${password#\\n}"
