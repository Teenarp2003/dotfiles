#!/bin/sh
# this script is formatted for polybar output. prerequisites involve setting up xrdb colors using pywal or the like. and bluetoothctl. 
session=$(echo $DESKTOP_SESSION)
color3=$(cat ~/.cache/wal/colors.ini | grep color14 | awk '{print $2}')
color4=$(cat ~/.cache/wal/colors.ini | grep color7 | awk '{print $2}')
color5=$(cat ~/.cache/wal/colors.ini | grep color6 | awk '{print $2}')
upower_final=$(~/.config/bin/bluetooth-battery.sh)

status=$(bluetoothctl show | awk 'NR==7'|awk '{$1=="";print $2}')
name=$(bluetoothctl devices Connected | awk '{print $3}'| awk '{sub(/^[[:space:]]+/, "", $0); print}')
name_temp=$(bluetoothctl devices Connected | awk '{$1="";$2="";print $0}')

# if string is greater than 4
if [[ ${#upower_final} -gt 4 ]]; then
  upower_final=""
fi 

bl=""
bl_hyprland=""
if [ "$status" = "no" ]; then
  bl="%{T7}%{F#808080}󰂯 %{T-}%{F-}"
  bl_hyprland="<span font_family='Iosevka Nerd Font'color='#808080' size='medium' >󰂯</span>"
elif [[ "$status" = "yes" && -z "$name" ]]; then
  bl= "%{T7}%{F#1793D1}󰂯 %{T-}%{F-}"
  bl_hyprland="<span font_family='Iosevka Nerd Font' color='#1793D1'size='medium' >󰂯</span>"
elif [ -n "$name" ]; then
  bl="%{T7}%{F#1793D1}󰂯 %{T-}%{F-}%{T4}%{F$color3}${name}%{T-}%{F-}%{T4}%{F$color5} ${upower_final} %{T-}%{F-}"
  bl_hyprland="<span font_family='Iosevka Nerd Font' color='#1793D1' size='medium' >󰂯</span> ${upower_final}"
fi
if [ "$session" == "hyprland" ]; then
    echo "$bl_hyprland"
  elif [ "$session" == "bspwm" ]; then
    echo "$bl"
fi
