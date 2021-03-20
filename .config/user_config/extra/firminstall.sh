#!/bin/sh

# Install all required firmware for this machine
# 'apt-file' package is needed

[ "$(whoami)" != 'root' ] && { printf 'This script needs root permission!\n'; exit 1; }
ping -c 1 8.8.8.8 >/dev/null 2>&1 || { printf 'No internet connection!\n'; exit 1; }

apt install apt-file -y || { printf 'An error occured!\n'; exit 1; }; printf '\n'
apt-file update || { printf 'An error occured!\n'; exit 1; }; printf '\n'
apt-file --package-only search /lib/firmware | xargs apt install -y || { printf 'An error occured!\n'; exit 1; }
