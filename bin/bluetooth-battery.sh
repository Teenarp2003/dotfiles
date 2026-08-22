#!/bin/bash


battery_info=$(upower -i $(upower -e | grep -ivE "bat|line|display")| grep percentage)

if [ -n "$battery_info" ]; then
    percentage=$(echo "$battery_info" | awk '{print $2}')
    echo "$percentage"
else
    echo "$device_name not found or battery information not available."
fi

