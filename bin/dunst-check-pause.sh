#!/bin/bash

dunst_status= $(dunstctl is-paused)
dunst_off= $(dunstctl set-paused toggle)
if [[ "$dunst_status" == "false" ]]; then
  notify-send.sh -t 500 --print-id --replace=10 "Focus Mode OFF" && $dunst_off
elif [[ "$dunst_status" == "true" ]]; then
  notify-send.sh -t 500 --print-id --replace=10 "Focus Mode ON" && $dunst_off
fi
 
