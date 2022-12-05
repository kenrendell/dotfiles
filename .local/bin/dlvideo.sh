#!/bin/sh
# Video/Audio downloader
# Dependencies: youtube-dl, ffmpeg, xdg-user-dirs
#
# Usage: dlvideo.sh [--audio] URL [URL...]

[ "$#" -le 1 ] && { { [ "$#" -eq 1 ] && [ "$1" != '--audio' ]; } || \
	{ printf 'Usage: dlvideo.sh [--audio] URL [URL...]\n' 1>&2; exit 1; }; }

directory="$(xdg-user-dir DOWNLOAD)"
audio_only=false

if [ "$1" = '--audio' ]; then shift
	format='bestaudio[acodec=opus]'
	template='%(title)s (%(abr)d kbps - %(asr)d Hz).%(ext)s'
	audio_only=true
else
	format='bestvideo[height<=720][vcodec=vp9]+bestaudio[acodec=opus]'
	template='%(title)s (%(resolution)s - %(fps)d fps).%(ext)s'
fi

while [ "$#" -ge 1 ]; do
	# Check the URL
	printf 'URL: %s\n' "$1"
	youtube-dl --simulate "$1" >/dev/null 2>&1 || \
		{ printf 'Please check the internet connection and URL!\n' 1>&2; exit 1; }

	if $audio_only; then youtube-dl --format "$format" --extract-audio --output "$directory/$template" "$1"
	else youtube-dl --format "$format" --merge-output-format mkv --output "$directory/$template" "$1"; fi

	[ "$#" -gt 1 ] && printf '\n'; shift
done
