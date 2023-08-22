#!/bin/bash
declare -A dictionary
dictionary["0x0"]="off"
dictionary["0x1"]="on"

declare -A power
power["0x0"]="balenced"
power["0x1"]="performance"
power["0x2"]="power saving"

replace_values() {
    while IFS= read -r line; do
        for key in "${!dictionary[@]}"; do
            line=${line//"$key"/"${dictionary[$key]}"}
        done
        printf "%s" "$line"
    done
}

replace_power() {
    while IFS= read -r line; do
        for key in "${!power[@]}"; do
            line=${line//"$key"/"${power[$key]}"}
        done
        printf "%s" "$line"
    done
}
printf "\n"
echo '\_SB.PCI0.LPC0.EC0.BTSM' > /proc/acpi/call
value=$(cat /proc/acpi/call | tr -d '\0')
clean_input=$(echo "$value" | replace_values)
echo "battery conservation: $clean_input"
echo '\_SB.PCI0.LPC0.EC0.QCHO' > /proc/acpi/call
value=$(cat /proc/acpi/call | tr -d '\0')
clean_input=$(echo "$value" | replace_values)
echo "rapid charge: $clean_input"
echo '\_SB.PCI0.LPC0.EC0.SPMO' > /proc/acpi/call
value=$(cat /proc/acpi/call | tr -d '\0')
clean_input=$(echo "$value" | replace_power)
echo "power mode: $clean_input"
