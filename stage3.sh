#!/usr/bin/env bash

# Package Upgrade & Init
sudo pacman -Syyu
sudo pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty nano neofetch cmatrix htop python-pip python-pywal lightdm lightdm-gtk-greeter dmenu

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
echo "#!/bin/bash
killall -q polybar
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown
echo "Polybar launched..."" > launch.sh && cd

install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

# Systemd Symlinks
systemctl enable lightdm.service
