#!/usr/bin/env bash

if ! command -v bluetoothctl &>/dev/null; then
  echo "{\"text\": \"󰂲\", \"tooltip\": \"bluetoothctl utility is missing\"}"
  exit 1
fi

# Check if Bluetooth is enabled
bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$bluetooth_status" = "no" ]; then
  echo "{\"text\": \"󰂲\", \"tooltip\": \"Bluetooth Disabled\"}"
  exit 0
fi

# Get connected devices
connected_devices=$(bluetoothctl devices Connected | wc -l)

if [ "$connected_devices" -eq 0 ]; then
  echo "{\"text\": \"󰂰\", \"tooltip\": \"Bluetooth Enabled - No devices connected\"}"
else
  # Get device names for tooltip
  device_list=$(bluetoothctl devices Connected | while read -r line; do
    device_name=$(echo "$line" | awk '{$1=$2=""; print substr($0, 3)}')
    echo ":: $device_name"
  done | tr '\n' '\n')
  
  echo "{\"text\": \"󰂱\", \"tooltip\": \"$connected_devices device(s) connected\n$device_list\"}"
fi
