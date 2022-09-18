#!/usr/bin/env bash

# Input Selection
read -p "Select Drive: " drivevar
echo "Using $drivevar.."
read -sp "Input Disk Encryption Password: " cryptvar
read -sp "Confirm Disk Encryption Password: " cryptvarconfirm
if [ "$cryptvar" == "$cryptvarconfirm" ]; then
    echo "Starting installation.."
    break
else
    echo "Password do not Match! Aborting installation.."
    exit
fi
