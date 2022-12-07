# Archinstall (DE)

### stage1.sh
- Partitioning & Formatting 
- Full Disk Encryption Setup via LVM
- Preparing Drives & chroot

### stage2.sh
- Set Hostname
- Change Root Passwd
- Setup User
- Sysclock config
- Vconsole config
- Localhost config
- Pacman init packages
- Mkinitcpio config
- Systembootd EFI installation

### init.sh - use this after rebooting into freshly installed arch
- Getting .config files
- Tweak personal preferences
- Installing BlackArch repo
- Installing yay
- Installing Fonts
