#!/usr/bin/env bash
# packages

sudo pacman -Syyu
sudo pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty nano neofetch cmatrix htop python-pip python-pywal lightdm lightdm-gtk-greeter

#YAY
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd && rm -rf yay/

#copying default configs
mkdir $HOME/.config/bspwm/
mkdir $HOME/.config/sxhkd/
mkdir $HOME/.config/polybar/

cp /etc/polybar/config.ini $HOME/.config/polybar/config.ini
cd .config/polybar && touch launch.sh
echo "#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."" > launch.sh
chmod +x launch.sh
cd

install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

systemctl enable lightdm.service
