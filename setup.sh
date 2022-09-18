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
#parted --script $sysdrive \
#    mklabel gpt \
#    mkpart ESP fat32 1MiB 512MiB \
#    mkpart primary linux-swap -8GiB 100% \
#    mkpart primary 0% 100%
    
parted $sysdrive -- mklabel gpt
parted $sysdrive -- mkpart ESP fat32 1MiB 512MiB
parted $sysdrive -- mkpart primary linux-swap -8GiB 100%
parted $sysdrive -- mkpart primary 0% 100%
parted $sysdrive -- set 1 esp on
