#!/usr/bin/env bash

# Username Input
read -p "[Enter Username]: " user

# Black Arch Repo Sync
curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh && sudo ./strap.sh 
rm -f strap.sh

# Package Sync & Init Installation
pacman -Syyu --noconfirm
# Desktop Env
pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty lightdm lightdm-gtk-greeter dmenu xorg xorg-utils xorg-drivers xorg-apps
# Misc Tools
pacman -S --noconfirm --needed nano neovim vim htop tree neofetch cmatrix python python-pip python-pywal

# .Config Struktur
mkdir -p ~/.config/bspwm/
mkdir -p ~/.config/sxhkd/
mkdir -p ~/.config/polybar/

# Polybar Init Config
cp /etc/polybar/config.ini ~/.config/polybar/config.ini
cd ~/.config/polybar
echo '#!/bin/bash
killall -q polybar
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown
echo "Polybar launched..."' > launch.sh && cd

# Lightdm Keyboard layout
echo 'Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection' > /etc/X11/xorg.conf.d/20-keyboard.conf

# Bswpm Init Config
install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

# Systemd Symlinks
systemctl enable lightdm.service

# User Privs
chown -Rv $user:$user /home/$user

# YAY
# git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd
# rm -rf yay
