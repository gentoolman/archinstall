#!/usr/bin/env bash

# Black Arch Repo Sync
curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh && sudo ./strap.sh 
rm -f strap.sh

# Package Sync & Init Installation
sudo pacman -Syyu
# Desktop Env
sudo pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty lightdm lightdm-gtk-greeter dmenu
# Misc
sudo pacman -S --noconfirm --needed nano neovim vim htop neofetch cmatrix python python-pip python-pywal

# YAY
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd
rm -rf yay

# .Config Struktur
mkdir –p ~/.config/bspwm/
mkdir ~/.config/sxhkd/
mkdir ~/.config/polybar/

# Polybar Init Config
cp /etc/polybar/config.ini ~/.config/polybar/config.ini
cd ~/.config/polybar
echo '#!/bin/bash
killall -q polybar
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown
echo "Polybar launched..."' > launch.sh && cd

# Bswpm?
install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

# Systemd Symlinks
systemctl enable lightdm.service
