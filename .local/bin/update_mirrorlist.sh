#!/bin/sh
# Update pacman mirrorlist

[ "$#" -eq 0 ] || { printf 'Usage: update_mirrorlist.sh\n'; exit 1; }

[ "$(whoami)" = 'root' ] || \
	{ printf 'Root permission is needed!\n'; exit 1; }

# Check internet connection
ping -c 2 archlinux.org >/dev/null 2>&1 || \
	{ printf 'No internet connection!\n'; exit 1; }

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Get the latest pacman mirrorlist
reflector --verbose --protocol https --latest 30 \
	--fastest 5 --save /etc/pacman.d/mirrorlist

# Enter `:n' and `:p' in `less' to search
# for next and previous file, respectively.
less /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

printf "Delete '/etc/pacman.d/mirrorlist.bak'? [y/(r)ecover/N]: "
read -r ans; case "$ans" in
	Y|y) rm -rf /etc/pacman.d/mirrorlist.bak ;;
	R|r) mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist ;;
esac
