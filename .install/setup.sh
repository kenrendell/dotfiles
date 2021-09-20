#!/bin/sh
# Script for setting up desktop session (wayland) on Arch linux.
# Usage: setup.sh USER

[ "$#" -eq 1 ] || { printf 'Usage: setup.sh USER\n'; exit 1; }

[ "$(whoami)" = 'root' ] || { printf 'Root permission is needed!\n'; exit 1; }

username="$1"
_HOME="/home/$username"
[ -d "$_HOME" ] || { printf 'Please provide a valid username!\n'; exit 1; }

# Check internet connection
ping -c 2 archlinux.org >/dev/null 2>&1 || \
	{ printf 'No internet connection!\n'; exit 1; }

pacman -Syu || { printf 'Failed to update system!\n'; exit 1; }
pacman -S --needed reflector || \
	{ printf 'Failed to install reflector package!\n'; exit 1; }

opts="
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 5
--sort rate
"

printf '%s' "$opts" | xargs reflector || \
	{ printf 'Failed to select mirrors!\n'; exit 1; }

pacman -Syu || { printf 'Failed to update system!\n'; exit 1; }

# Install packages
sed --posix -nE 's/^[[:space:]]*\*[[:space:]]*([[:alnum:]-]*)$/\1/p' \
	"$_HOME/packages.txt" | pacman -S --needed - || \
	{ printf 'Failed to install packages!\n.\n'; exit 1; }

# Generate a GRUB configuration file
grub-mkconfig -o /boot/grub/grub.cfg

# Install AUR helper
su --pty --login "$username" -c "\
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	makepkg -si
	cd ..
	rm -rf paru-bin
"

# Install AUR packages
if command -v paru >/dev/null 2>&1; then
	sed --posix -nE 's/^[[:space:]]*@[[:space:]]*([[:alnum:]-]*)$/\1/p' \
		"$_HOME/packages.txt" | paru -S --needed - || \
		{ printf 'Failed to AUR packages!\n.\n'; exit 1; }
fi

# Configure the virtual console
printf 'KEYMAP=us1\nFONT=ter-v14n\n' > /etc/vconsole.conf

# Add user to video and audio group
usermod -a -G audio,video "$username"

# Change user default shell to zsh
usermod -s /bin/zsh "$username"

# Load generic bluetooth driver 'btusb' if not loaded.
grep '^btusb\>' /proc/modules >/dev/null 2>&1 || modprobe btusb
systemctl --now enable bluetooth.service

# Enable tlp for power saving
systemctl --now enable tlp.service

# Enable network manager
systemctl --now enable NetworkManager.service

# Enable firewall
ufw enable
systemctl --now enable ufw.service
