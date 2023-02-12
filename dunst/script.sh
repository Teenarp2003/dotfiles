#!/bin/sh
 
# Source the colors from wal
source "${HOME}/.cache/wal/colors.sh"
 
ln -sf    "${HOME}/.cache/wal/dunstrc"    "${HOME}/.config/dunst/dunstrc"
ln -sf    "${HOME}/.cache/wal/cavaconfig"    "${HOME}/.config/cava/config"
 
# Restart dunst with the new color scheme
pkill dunst
dunst &
