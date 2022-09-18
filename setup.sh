#!/usr/bin/env bash

# Drive Selection
read -p "Select Drive: " sysdrive

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
  echo +16G; # SWAP (16GB)
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
