#!/bin/bash
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
rm -rf yay-git
mkdir ~/bin
sudo pacman -S python-pywal

cp ~/.config/scripts-custom/colors-alacritty.yml /usr/lib/python3.10/site-packages/pywal/templates/
cp ~/.config/scripts-custom/colors.ini /usr/lib/python3.10/site-packages/pywal/templates/
cp ~/.config/scripts-custom/colors.rasi /usr/lib/python3.10/site-packages/pywal/templates/

cp ~/.config/scripts-custom/randwal ~/bin/
cp ~/.config/scripts-custom/glava-colors ~/bin/
cp ~/.config/scripts-custom/brightness ~/bin/
cp ~/.config/scripts-custom/volume-up ~/bin/

