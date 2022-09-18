#!/usr/bin/env bash

# Grub Installation
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
blkid -s UUID -o value /dev/sda3 > uuid.tmp
uuid=$(<uuid.tmp)
sed --in-place=.bak 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cryptdevice=UUID=$uuid:cryptdisk root=\/dev\/mapper\/cryptdisk"/' /etc/default/grub
rm -f uuid.tmp
