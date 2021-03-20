#!/bin/sh

# Make a bootable usb for linux image
# Arg 1 = iso image path 
# Arg 2 = block devices (such as /dev/sda, /dev/sdb, etc)

[ "$#" -ne 2 ] && { printf 'Arg 1 = linux image (.iso file)\nArg 2 = block devices (such as /dev/sda, /dev/sdb, etc)\n'; exit 1; }
[ -f "$1" ] || { printf 'No such file named "%s"\n' "$1"; exit 1; }
[ -b "$2" ] || { printf 'No such block device named "%s"\n' "$2"; exit 1; }

sudo sh -c "umount '$2'*; mkfs.ext4 '$2'; dd if='$1' of='$2' status='progress'"
