#!/bin/sh
# Bookmark command for Newsboat
# Dependency: newsboat, xdg-user-dirs
#
# Usage: newsboat-bookmark.sh <URL> <title> <description> <feed-title>

[ "$#" -eq 4 ] || { printf 'This program needs exactly 4 arguments!\n'; exit 1; }
[ -n "${url=$1}" ] || { printf 'The URL of this article is empty!\n'; exit 1; }

title="${2:-none}"
desc="${3:-none}"
feed="${4:-none}"
directory="$(xdg-user-dir DOCUMENTS)"
bookmark="$directory/newsboat-bookmark.txt"

bookmark_write() {
	printf '%bURL: %s\nTitle: %s\nDescription: %s\nFeed: %s\n' \
		"$1" "$url" "$title" "$desc" "$feed" >> "$bookmark"
}; mkdir -p "$directory"
if [ -f "$bookmark" ]; then
	grep --quiet "^URL:[[:space:]]*$1\$" "$bookmark" && \
		{ printf 'This article already exists in bookmark!\n'; exit 1; }
	bookmark_write '\n'
else bookmark_write; fi
