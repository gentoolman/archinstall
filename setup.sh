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
parted --script $sysdrive \
    mklabel gpt \
    p \
