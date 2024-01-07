#!/bin/sh
# this script is formatted for polybar output. prerequisites involve setting up xrdb colors using pywal or the like. and bluetoothctl. 
color3=$(cat ~/.cache/wal/colors.ini | grep color14 | awk '{print $2}')
color4=$(cat ~/.cache/wal/colors.ini | grep color7 | awk '{print $2}')
upower_i="/org/freedesktop/UPower/devices/headset_dev_"
MAC=$(bluetoothctl devices Connected | awk '{$1="";$3="";$4="";$5="";print $0}'|awk '{gsub(" ", ""); print}'|awk '{gsub(" ", ""); gsub(":", "_"); print}')
upower_final=$(bluetooth-battery.sh $upower_i$MAC)
status=$(bluetoothctl show | awk 'NR==7'|awk '{$1=="";print $2}')
name=$(bluetoothctl devices Connected | awk '{$1="";$2="";$3="";print $0}'| awk '{sub(/^[[:space:]]+/, "", $0); print}')
name_temp=$(bluetoothctl devices Connected | awk '{$1="";$2="";print $0}')

# if string is greater than 4
if [[ ${#upower_final} -gt 4 ]]; then
  upower_final=""
fi 
if [ "$status" = "no" ]; then
  echo "%{T3}%{F#808080}󰂯%{T-}%{F-}"
elif [[ "$status" = "yes" && -z "$name" ]]; then
  echo "%{T3}%{F#1793D1}󰂯%{T-}%{F-}"
elif [ -n "$name" ]; then
    echo "%{T3}%{F#1793D1}󰂯 %{T-}%{F-}%{T3}%{F$color3}${name}%{T-}%{F-}%{T3}%{F$color4} ${upower_final}%{T-}%{F-}"
fi
echo $upower_final
