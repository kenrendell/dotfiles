#!/bin/sh
# Toggle camera
# Dependencies: sudo, bemenu

unset option
[ "$#" -eq 1 ] && [ "$1" = '--ask-pass' ] && { option="$1"; shift; }
[ "$#" -eq 0 ] || { printf 'Usage: toggle-camera.sh [--ask-pass]\n' 1>&2; exit 1; }

module_name='uvcvideo'
if grep -q "^${module_name}[[:blank:]]" '/proc/modules'; then
	eval "sudo ${option+'--askpass'} modprobe --quiet --remove '${module_name}'"
else eval "sudo ${option+'--askpass'} modprobe --quiet '${module_name}'"; fi
