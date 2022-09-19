#!/usr/bin/env bash

# Drive Selection
read -p "[Select Drive]: " sysdrive

# Disk Encryption Selection
read -srep "[Enter Disk Encryption Password]: " pass
read -sp "[Confirm Disk Encryption Password]: " passconfirm
echo "*"
if [ "$pass" == "$passconfirm" ]; then
    echo "Starting Installation on $sysdrive.."
else
    echo "Password do not Match! Aborting installation.."
    exit
fi

# Partitioning
wipefs $sysdrivehttps://github.com/archungus333/archinstall/blob/main/stage1.sh
(
  echo g;
  echo n;
  echo ;
  echo ;
  echo +512M; # EFI (512MiB)
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
mkfs.vfat -F32 -n EFI $sysdrive"1"

# Setup Encrypted LUKS
# echo $pass | cryptsetup --use-random luksFormat $sysdrive"2" -d -
# echo $pass | cryptsetup luksOpen $sysdrive"2" luks -d -
cryptsetup --use-random luksFormat $sysdrive"2"
cryptsetup luksOpen $sysdrive"2" luks

# Setup LVM
pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate --size 4G vg0 --name swap # 4GB SWAP
lvcreate -l +100%FREE vg0 --name root # Remaining -> Primary

# Format LVM
mkfs.ext4 -L root /dev/mapper/vg0-root
mkswap /dev/mapper/vg0-swap
swapon /dev/mapper/vg0-swap

# Mount System
mount /dev/mapper/vg0-root /mnt
mount --mkdir $sysdrive"1" /mnt/boot 

# Prepare Base System
pacstrap /mnt base base-devel linux linux-firmware sudo efibootmgr lvm2 dialog wpa_supplicant tmux intel-ucode zsh neovim git 
genfstab -pU /mnt | tee -a /mnt/etc/fstab
git clone https://github.com/archungus333/archinstall.git /mnt/root/archinstall
arch-chroot /mnt /bin/bash
