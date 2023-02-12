#!/bin/bash
set -eu -o pipefail # fail on error and report it, debug all lines
sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"
echo "updating packages"
sudo pacman -Syy
echo "installing packages"
echo "you have 5 seconds"
echo "Press Ctrl + C to cancel"
echo -e "\n"
sleep 6
while read line; do sudo pacman -S --noconfirm $line ; done < pkglist.txt
echo "installing yay"
git clone https://aur.archlinux.org/yay.git
sudo chown -R  cloudcone:users yay
cd yay
makepkg -si
while read line; do yay -S --noconfirm $line ; done < pkglist_aur.txt
sudo pacman -Syu

