#!/usr/bin/env bash

# Input Selection
read -p "Select Drive: " drivevar
echo "Using $drivevar.."
echo "Input Disk Encryption Password: " 1>&2
read -sp cryptvar
echo "Confirm Disk Encryption Password: " 1>&2
read -sp cryptvarconfirm
if [ "$cryptvar" == "$cryptvarconfirm" ]; then
    echo "Starting installation.."
    break
else
    echo "Password do not Match! Aborting installation.."
    exit
fi
