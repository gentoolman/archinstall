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
(
  echo g;
  echo n;
  echo ;
  echo ;
  echo +512M;
  echo n;
  echo ;
  echo ;
  echo +16G;
  echo n;
  echo ;
  echo ;
  echo ;
  echo t;
  echo 1;
  echo 1;
  echo t;
  echo ;
  echo 19;
  echo w;
) | fdisk $sysdrive
