#!/usr/bin/env bash

# Drive Selection
read -p "Select Drive: " sysdrive
read -p "Enter Hostname: " hostname

# Disk Encryption Selection
read -srep "Enter Disk Encryption Password: " pass
read -sp "Confirm Disk Encryption Password: " passconfirm
echo "*"
if [ "$pass" == "$passconfirm" ]; then
    echo "Starting installation.."
else
    echo "Password do not Match! Aborting installation.."
    exit
fi

# Partitioning
wipefs $sysdrive
(
  echo g;
  echo n;
  echo ;
  echo ;
  echo +512M; # EFI (512MiB)
  echo n;
  echo ;
  echo ;
  echo +8G; # SWAP (16GB)
  echo n;
  echo ;
  echo ;
  echo ; # PRIMARY (Remaining Space)
  echo t;
  echo 1;
  echo 1;
  echo t;
  echo ;
  echo 19;
  echo w;
) | fdisk $sysdrive

# Format EFI
mkfs.fat -F 32 $sysdrive"1"

# Format Swap
mkswap $sysdrive"2"
swapon $sysdrive"2"

# Format & Encrypt Primary
echo $pass | cryptsetup luksFormat -v -s 512 -h sha512 $sysdrive"3" -d -
echo $pass | cryptsetup open $sysdrive"3" cryptdisk -d -
mkfs.ext4 /dev/mapper/cryptdisk

# Prepare Drive & chroot
mkdir /mnt/boot
mount /dev/mapper/cryptdisk /mnt
mount $sysdrive"1" /mnt/boot
pacstrap /mnt base linux linux-firmware intel-ucode vim nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# System Installation
# Sys Clock
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
# Locale
sed --in-place=.bak 's/^#de_DE\.UTF-8/de_DE\.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=de_DE.UTF-8 > /etc/locale.conf
# Set Hostname 
echo $hostname > /etc/hostname
