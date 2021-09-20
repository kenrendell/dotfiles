# Arch linux installation guide
# BIOS system

# Set console font (/usr/share/kbd/consolefonts/)
setfont ter-v14n

pacstrap /mnt base linux-lts linux-firmware grub networkmanager neovim sudo git

# Install bootloader (for example, '/dev/sda' not partition '/dev/sdaN')
grub-install --target=i386-pc /dev/sdX
