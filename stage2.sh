#!/usr/bin/env bash

# Set Hostname 
read -p "[Enter Hostname]: " hostname
echo $hostname > /etc/hostname

# Setup Root Password
echo "[Enter Root Passwd]"
passwd

# Sys Clock
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# Locale
sed --in-place=.bak 's/^#de_DE\.UTF-8/de_DE\.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo LC_ALL= >> /etc/locale.conf

# Vconsole
echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf

# Hosts file
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

# Pacman
pacman -Sy
pacman -Syu
pacman --noconfirm -S networkmanager wireless_tools mtools reflector linux-headers bluez bluez-utils cups xdg-utils xdg-user-dirs pulseaudio-bluetooth

# Mkinitcpio Config
sed --in-place=.bak 's/^MODULES=()/MODULES=(ext4)/' /etc/mkinitcpio.conf
sed --in-place=.bak 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# Systembootd Setup
bootctl --path=/boot install
echo default arch >> /boot/loader/loader.conf
echo timeout 5 >> /boot/loader/loader.conf
blkid -s UUID -o value /dev/sda2 > uuid.tmp
uuid=$(<uuid.tmp)
echo "title Arch Linux" >> /efi/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=$uuid:vg0 root=/dev/mapper/vg0-root" >> /efi/loader/entries/arch.conf
# resume=/dev/mapper/vg0-swap rw intel_pstate=no_hwp

# Systemd
systemctl enable NetworkManager
systemctl enable bluetooth
