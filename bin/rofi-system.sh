#!/bin/bash
dir="/home/teenarp2026/.config/rofi"
theme='sudo-config'
# Define the options
options=("Battery Conservation Mode" "Rapid Charging Mode" "Performance Mode")

# Prompt the user to select an option
selected_option=$(printf '%s\n' "${options[@]}" | rofi -dmenu -theme ${dir}/${theme}.rasi -i -p "Select a mode")

# Check the selected option and display the appropriate submenu
case $selected_option in
    "Battery Conservation Mode")
        submenu=("Turn On" "Turn Off" )
        selected_submenu=$(printf '%s\n' "${submenu[@]}" | rofi -dmenu -theme ${dir}/${theme}.rasi -i -p "Battery Conservation Mode Submenu")
        # Perform actions based on the selected submenu option
        case $selected_submenu in
            "Turn On")
                # Execute the command as sudo
                echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x03' > /proc/acpi/call && echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' > /proc/acpi/call && output=$(sudo display-hwmode.sh) && sudo -u teenarp2026 DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -t 3000 "Settings Changed!" "$output"
                ;;
            "Turn Off")
                # Add your code here for Option 2 in Battery Conservation mode
                echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05' > /proc/acpi/call && output=$(sudo display-hwmode.sh) && sudo -u teenarp2026 DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -t 3000 'Settings Changed!' "$output"
                ;;
            "Option 3")
                # Add your code here for Option 3 in Battery Conservation Mode submenu
                ;;
        esac
        ;;
    "Rapid Charging Mode")
      submenu=("Turn On" "Turn Off")
        selected_submenu=$(printf '%s\n' "${submenu[@]}" | rofi -dmenu -theme ${dir}/${theme}.rasi -i -p "Rapid Charging Mode Submenu")
        # Perform actions based on the selected submenu option
        # Add your code here for the Rapid Charging Mode submenu
        case $selected_submenu in
          "Turn On")
            echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' > /proc/acpi/call && output=$(sudo display-hwmode.sh) && sudo -u teenarp2026 DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -t 3000 'Settings Changed!' "$output"
            ;;
          "Turn Off")
            echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' > /proc/acpi/call && output=$(sudo display-hwmode.sh) && sudo -u teenarp2026 DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send -t 3000 'Settings Changed!' "$output"
            ;;
        esac
        ;;
    "Performance Mode")
        output=$(sudo display-hwmode.sh) && notify-send -t 3000 'Settings Listed' "$output"
        ;;
    *)
        exit 0
        ;;
esac
