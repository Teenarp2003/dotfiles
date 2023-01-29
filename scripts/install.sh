#!/bin/bash
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
rm -rf yay-git
