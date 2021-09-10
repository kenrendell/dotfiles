#!/bin/sh
# Video/Audio downloader with 'youtube-dl'
# Dependencies: youtube-dl, ffmpeg
#
# Usage: dlvideo.sh [--audio] URL [URL...]

[ "$#" -le 1 ] && { { [ "$#" -eq 1 ] && [ "$1" != '--audio' ]; } || \
    { printf 'Usage: dlvideo.sh [--audio] URL [URL...]\n' 1>&2; return 1; }; }

if [ "$1" = '--audio' ]; then shift
    dir="$HOME/Musics/new"
    template='%(title)s (%(abr)d kbps).%(ext)s'
    format="
        bestaudio[ext=m4a]/
        bestaudio[ext=mp3]/
        bestaudio[ext=webm]/
        bestaudio
    "
else
    dir="$HOME/Videos/new"
    template='%(title)s (%(resolution)s - %(tbr)d kbps).%(ext)s'
    size=720
    format="
        best[ext=mp4][height<=${size}][width<=${size}]/
        bestvideo[ext=mp4][height<=${size}][width<=${size}]+bestaudio[ext=m4a]/
        best[ext=webm][height<=${size}][width<=${size}]/
        bestvideo[ext=webm][height<=${size}][width<=${size}]+bestaudio[ext=webm]/
        best[height<=${size}][width<=${size}]/
        bestvideo[height<=${size}][width<=${size}]+bestaudio
    "
fi

format="$(printf '%s' "$format" | tr -d '[:space:]')"

while [ "$#" -ge 1 ]; do
    # Check network connection
    ping -c 1 8.8.8.8 >/dev/null 2>&1 || \
        { printf '\033[38;5;1mNo internet connection!\033[m\n'; return 1; }

    # Print the URL
    printf '\033[38;5;4mURL\033[m: \033[38;5;3m%s\033[m\n' "$1"

    # Check the URL validity
    if youtube-dl --simulate "$1" >/dev/null 2>&1; then
        mkdir -p "$dir"
        youtube-dl --output "$dir/$template" --format "$format" "$1"
    else
        printf '\033[38;5;1mInvalid URL!\033[m\n'
    fi

    [ "$#" -gt 1 ] && printf '\n'; shift
done
