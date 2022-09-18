#!/usr/bin/env bash

# Drive Selection
read -p "Select Drive: " sysdrive

# Disk Encryption Selection
read -srep "Enter Disk Encryption Password: " crypt
read -sp "Confirm Disk Encryption Password: " cryptconfirm
echo "*"
if [ "$crypt" == "$cryptconfirm" ]; then
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
mkfs.fat -F 32 $sysdrive1

# Format Swap
mkswap $sysdrive2
swapon $sysdrive2

# Format Primary
mkfs.ext4 $sysdrive3
