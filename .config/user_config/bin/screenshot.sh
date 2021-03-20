#!/bin/sh

path="$HOME/Pictures/Screenshots"
mkdir -p "$path"
deepin-screenshot -s "$path" &
