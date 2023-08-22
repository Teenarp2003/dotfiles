#!/bin/sh
# this script is formatted for polybar output. prerequisites involve setting up xrdb colors using pywal or the like. and bluetoothctl. 
color3=$(xrdb -query | grep 'color3:' | awk '{print $2}'|awk 'NR==1')
status=$(bluetoothctl show | awk 'NR==5'|awk '{$1=="";print $2}')
name=$(bluetoothctl devices Connected | awk '{$1="";$2="";$3="";print $0}'| awk '{sub(/^[[:space:]]+/, "", $0); print}')
if [ "$status" = "no" ]; then
  echo "%{T3}%{F#808080}󰂯%{T-}%{F-}"
elif [[ "$status" = "yes" && -z "$name" ]]; then
  echo "%{T3}%{F#1793D1}󰂯%{T-}%{F-}"
elif [ -n "$name" ]; then
    echo "%{T3}%{F#1793D1}󰂯 %{T-}%{F-}%{T3}%{F$color3}${name}%{T-}%{F-}"
fi
