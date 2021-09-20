#!/bin/sh

root_uuid="$(lsblk -o MOUNTPOINT,UUID | sed --posix -nE 's/^[[:space:]]*\/[[:space:]]+(.+)[[:space:]]*$/\1/p')"
part_type="$(fdisk -l /dev/sda | sed --posix -nE 's/^[[:space:]]*Disklabel type:[[:space:]]*(.+)$/\1/p')"
root_fstype="$(lsblk -o MOUNTPOINT,FSTYPE | sed --posix -nE 's/^[[:space:]]*\/[[:space:]]+(.+)[[:space:]]*$/\1/p')"

case "$part_type" in
	dos) part_module='part_msdos';;
	gpt) part_module='part_gpt';;
esac

case "$root_fstype" in
	f2fs) fs_module='f2fs';;
	ext4) fs_module='';;
esac
