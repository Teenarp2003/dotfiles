#!/bin/bash
sudo pacman -S --noconfirm bspwm sxhkd polybar picom alacritty rofi glava lxsession dunst nitrogen adobe-source-code-pro-fonts playerctl
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
rm -rf yay-git
yay -S --noconfirm nerd-fonts-cascadia-code nerd-fonts-meslo nerd-fonts-mononoki
git clone https://github.com/teenarp2003/dotfiles.git .config
