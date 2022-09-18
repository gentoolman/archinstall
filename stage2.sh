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

# Vconsole
echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf

# Hosts file
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

# Pacman
pacman -Sy
pacman -Syu
pacman --noconfirm -S efibootmgr grub networkmanager wireless_tools wpa_supplicant mtools os-prober reflector base-devel linux-headers bluez bluez-utils cups xdg-utils xdg-user-dirs pulseaudio-bluetooth

# Mkinitcpio Conf
sed --in-place=.bak 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# Grub Installation
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
blkid -s UUID -o value /dev/sda3 > uuid.tmp
uuid=$(<uuid.tmp)
sed --in-place=.bak 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cryptdevice=UUID='$uuid':cryptdisk root=\/dev\/mapper\/cryptdisk"/' /etc/default/grub
rm -f uuid.tmp
grub-mkconfig -o /boot/grub/grub.cfg
