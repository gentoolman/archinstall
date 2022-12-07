#!/usr/bin/env bash

# Package Sync & Init Installation
sudo pacman -Syyu --noconfirm

# Desktop Env
sudo pacman -S --noconfirm --needed xorg xorg-server xorg-apps bspwm sxhkd polybar picom nitrogen kitty lightdm lightdm-gtk-greeter dmenu 

# Misc Tools
sudo pacman -S --noconfirm --needed nano btop neovim htop tree neofetch cmatrix python python-pip python-pywal pulseaudio-bluetooth sof-firmware thunar discord s-tui git

# dot files
mkdir /home/$USER/Downloads
cd /home/$USER/Downloads
git clone https://github.com/gentoolman/bspwmdots
cd
cp -rf Downloads/bspwmdots/.config /home/$USER/
cp -rf Downloads/bspwmdots/.bashrc /home/$USER/

chmod +x .config/bspwm/bspwmrc
chmod +x .config/bspwm/pywal.sh
chmod +x .config/polybar/launch.sh

# Systemd Symlinks & priviliges
read -p "[Enter your username]: " username
sudo systemctl enable lightdm.service
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo usermod -a -G video $username
sudo echo "ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"" >> /etc/udev/rules.d/backlight.rules

# YAY
sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Fonts
pacman -S --noconfirm ttf-font-awesome
yay -S nerd-fonts-complete --needed --noconfirm

sudo fc-cache -fv
# Tweaking
cd
mv Bilder/ Pictures/
mv Dokumente/ Documents/
mv Schreibtisch/ Desktop/
rm -rf Musik/ Öffentlich/ Videos/ Vorlagen/

# Blackarch 
curl -O https://blackarch.org/strap.sh
$ echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh
rm -rf strap.sh
echo " "
echo " "
echo "###########################################"
echo "#										                    	#"
echo "#	UNCOMMENT MULTILAB IN /etc/pacman.conf	#"
echo "#			AFTER THAT  pacman -Syu	          	#"
echo "#										                    	#"
echo "###########################################"
