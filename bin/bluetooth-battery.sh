#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <device_name>"
    exit 1
fi

device_name="$1"

battery_info=$(upower -i $(upower -e | grep "$device_name") | grep percentage)

if [ -n "$battery_info" ]; then
    percentage=$(echo "$battery_info" | awk '{print $2}')
    echo "$percentage"
else
    echo "$device_name not found or battery information not available."
fi

