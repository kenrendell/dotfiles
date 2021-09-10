#!/bin/sh
# Script for setting up desktop session (wayland) on Arch linux.
# Usage: setup.sh USER

[ "$#" -eq 1 ] || { printf 'Usage: setup.sh USER\n'; exit 1; }

[ "$(whoami)" = 'root' ] || { printf 'Root permission is needed!\n'; exit 1; }

[ -d "/home/$1" ] || { printf 'Please provide a valid username!\n'; exit 1; }

# Check internet connection
ping -c 5 archlinux.org >/dev/null 2>&1 || \
    { printf 'No internet connection!\n'; exit 1; }

# Updating packages
pacman -Syu || { printf 'An error occured while updating packages.\n'; exit 1; }

# Installing packages
{ sed --posix -nE 's/^[[:space:]]*\*[[:space:]]*([[:alnum:]-]*)$/\1/p' \
    "/home/$1/packages.txt" | xargs pacman -S; } || \
    { printf 'An error occured while installing packages.\n'; exit 1; }

# Add username to sudo group
usermod -a -G sudo "$1"

# Change default shell to zsh
chsh -s "$(command -v zsh)" "$1"

# Load generic bluetooth driver 'btusb' if not loaded.
grep '^btusb\>' /proc/modules >/dev/null 2>&1 || modprobe btusb

# Enable firewall
ufw enable

# Removing unused packages (orphans)
pacman -Qtdq | pacman -Rns -
