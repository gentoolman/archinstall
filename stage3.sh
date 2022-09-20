#!/usr/bin/env bash

# Black Arch Repo Sync
sudo curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
sudo chmod +x strap.sh && sudo ./strap.sh 
sudo rm -f strap.sh

# Package Sync & Init Installation
sudo pacman -Syyu --noconfirm
# Desktop Env
sudo pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty lightdm lightdm-gtk-greeter dmenu xorg
# Misc
sudo pacman -S --noconfirm --needed nano neovim vim htop neofetch cmatrix python python-pip python-pywal

# YAY
sudo git clone https://aur.archlinux.org/yay.git && chown archungus:archungus yay && cd yay && makepkg -si && cd
sudo rm -rf yay

# .Config Struktur
sudo mkdir –p ~/.config/bspwm/
sudo mkdir ~/.config/sxhkd/
sudo mkdir ~/.config/polybar/

# Polybar Init Config
cp /etc/polybar/config.ini ~/.config/polybar/config.ini
cd ~/.config/polybar
echo '#!/bin/bash
killall -q polybar
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown
echo "Polybar launched..."' > launch.sh && cd

# Lightdm Keyboard layout
sudo echo 'Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection' > /etc/X11/xorg.conf.d/20-keyboard.conf

# Bswpm?
# sudo install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
# sudo install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

# Systemd Symlinks
sudo systemctl enable lightdm.service
