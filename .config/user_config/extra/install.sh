#!/bin/sh

[ "$(whoami)" != 'root' ] && { printf 'This script needs root permission!\n'; exit 1; }
ping -c 1 8.8.8.8 >/dev/null 2>&1 || { printf 'No internet connection!\n'; exit 1; }

printf 'Username: '; read -r user
config_dir="/home/$user/.config/user_config"
packages="$(eval "printf '%s' \"$(grep '\*' "$config_dir/extra/packages.txt" | cut -d '*' -f 2)\"")"

# Set default backlight
acpi_video='/sys/class/backlight/acpi_video0'
[ -d "$acpi_video" ] && printf '1\n' > "$acpi_video/brightness"

# Install the required packages
apt update || { printf 'An error occured!\n'; exit 1; }; printf '\n'
printf '%s' "$packages" | xargs apt install -y || { printf 'An error occured!\n'; exit 1; }

# Add username to sudo group
/usr/sbin/usermod -aG sudo "$user"

# Change default shell to zsh
chsh -s "$(which zsh)" "$user"

# Enable firewall
printf '\nSetting up firewall...\n'
/usr/sbin/ufw allow ssh
/usr/sbin/ufw enable

# Enable hddtemp network daemon
sed -i -e '/RUN_DAEMON/s/".*"/"true"/' /etc/default/hddtemp

# Compiling suckless software
make -C "$config_dir/suckless/st" clean install
make -C "$config_dir/suckless/dmenu" clean install
make -C "$config_dir/suckless/slock" clean install
rm -rf "$config_dir/suckless/st/config.h" \
    "$config_dir/suckless/dmenu/config.h" \
    "$config_dir/suckless/slock/config.h"
