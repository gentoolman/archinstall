#!/usr/bin/env bash

# Set Hostname 
read -p "[Enter Hostname]: " hostname
echo $hostname > /etc/hostname

# Setup Root Password
read -sp "[Enter root passwd]: " pass
passwd "$pass" --stdin

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
