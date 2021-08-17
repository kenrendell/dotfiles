#!/bin/sh

killall -q waybar
while pidof waybar >/dev/null; do sleep 1; done
waybar &
