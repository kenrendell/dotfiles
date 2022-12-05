#!/bin/sh
# MTP device [un]mounter
# Dependencies: gvfs-mtp
#
# Usage: mount_mtp.sh

[ "$#" -eq 0 ] || { printf 'Usage: mount_mtp.sh\n'; exit 1; }

help="Directory: \$XDG_RUNTIME_DIR/gvfs/
Commands:
 (q) quit
 (m) mount all devices
 (u) unmount all devices
 (n) toggle [un]mount of device 'n' (can be separated by space)
 (l) show the updated list of devices
"

get_mtp() {
	devs="$(gio mount -li | sed -E -n 's/^[[:space:]]*activation_root=(.+)$/\1/p' | xargs)"
	mnt_devs=" $(gio mount -l | sed -E -n 's/^Mount\([0-9]+\):.*(mtp:.+)$/\1/p' | xargs) "
}

list_mtp() {
	get_mtp; count=1
	printf 'Device List:\n'
	for dev in $devs; do
		if [ -z "${mnt_devs##*[[:space:]]${dev}[[:space:]]*}" ]
		then printf ' [*] '; else printf ' [ ] '; fi
		printf '%d: %s\n' "$count" "$dev"
		count=$((count + 1))
	done; printf '\n'
}

printf "Enter 'h' for more information.\n"
while [ "${input=l}" != 'q' ]; do
	if printf '%s\n' "$input" | grep -q '^[0-9[:space:]]\+$'; then
		to_mnt_devs=' '; to_umnt_devs=' '
		for n in $input; do
			dev="$(printf '%s \n' "$devs" | cut -d ' ' -f "$n")"
			[ -z "$dev" ] && { printf "device %d is not available\n" "$n"; continue; }
			if [ -z "${mnt_devs##*[[:space:]]${dev}[[:space:]]*}" ]
			then [ -z "${to_umnt_devs##*[[:space:]]${dev}[[:space:]]*}" ] || \
				to_umnt_devs="${to_umnt_devs}$dev "
			else [ -z "${to_mnt_devs##*[[:space:]]${dev}[[:space:]]*}" ] || \
				to_mnt_devs="${to_mnt_devs}$dev "
			fi
		done
		[ "$to_mnt_devs" = ' ' ] || { gio mount $to_mnt_devs & }
		[ "$to_umnt_devs" = ' ' ] || { gio mount -u $to_umnt_devs & }
		wait; [ "$to_mnt_devs" = "$to_umnt_devs" ] || get_mtp
	else case "$input" in
		l) list_mtp ;;
		h) printf '%s\n' "$help" ;;
		m) [ -n "$devs" ] && { gio mount $devs; get_mtp; } ;;
		u) [ -n "$devs" ] && { gio mount -u $devs; get_mtp; } ;;
		*) [ -n "$input" ] && printf 'invalid input!\n' ;;
	esac; fi
	printf '> '; read -r input
done
