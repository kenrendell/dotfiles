#!/bin/sh

pidof -x pactl | xargs kill

pactl subscribe | while read -r output; do
    if printf '%s' "$output" | grep 'sink'; then
        pidof -x audio_output.sh | xargs kill -USR1
    elif printf '%s' "$output" | grep 'source'; then
        pidof -x audio_input.sh | xargs kill -USR1
    fi
done
