#!/bin/bash
getmic=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
if [ "$getmic" == "yes" ]; then
    eval notify-send.sh -t 1000 --print-id --replace=10 "󰍭 Mic MUTE"
else
    eval notify-send.sh -t 1000 --print-id --replace=10 "󰍬 Mic UNMUTE"
fi
