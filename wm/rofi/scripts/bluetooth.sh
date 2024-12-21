#!/bin/bash

# Function to get list of Bluetooth devices
get_bluetooth_devices() {
  bluetoothctl devices | while read -r line; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d ' ' -f 3-)
    paired=$(bluetoothctl info "$mac" | grep "Paired" | awk '{print $2}')
    connected=$(bluetoothctl info "$mac" | grep "Connected" | awk '{print $2}')
    trusted=$(bluetoothctl info "$mac" | grep "Trusted" | awk '{print $2}')

    status=""
    [ "$paired" == "yes" ] && status="$status Paired"
    [ "$connected" == "yes" ] && status="$status Connected"
    [ "$trusted" == "yes" ] && status="$status Trusted"

    echo -e "$mac\t$name\t$status"
  done
}

# Function to display devices in Rofi and handle selection
display_rofi_menu() {
  local devices
  devices=$(get_bluetooth_devices | awk -F'\t' '{print $2 " - " $3}')
  selected=$(echo -e "$devices" | rofi -dmenu -i -p "Bluetooth Devices")

  if [ -n "$selected" ]; then
    local mac
    mac=$(get_bluetooth_devices | grep "$selected" | awk -F'\t' '{print $1}')

    if [ "$(echo "$selected" | grep -o 'Connected')" == "Connected" ]; then
      bluetoothctl disconnect "$mac"
    else
      bluetoothctl connect "$mac"
    fi
  fi
}

display_rofi_menu

