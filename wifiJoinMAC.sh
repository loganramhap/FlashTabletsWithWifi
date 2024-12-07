#!/bin/bash

# Prompt for inputs
read -p "Enter the Wi-Fi SSID: " SSID
read -p "Enter the Wi-Fi Password: " PASSWORD
read -p "Enter the password type (default 'WPA'): " PASSWORD_TYPE
PASSWORD_TYPE=${PASSWORD_TYPE:-WPA}

# Get the list of connected devices
DEVICES=$(adb devices | awk 'NR>1 && /device$/ {print $1}')

# Check if any devices are connected
if [ -z "$DEVICES" ]; then
  echo "No devices connected."
  exit 1
fi

# Iterate over each connected device
echo "Found devices:"
echo "$DEVICES"
for DEVICE in $DEVICES; do
  echo "Connecting to Wi-Fi on device $DEVICE..."
  adb -s "$DEVICE" shell am start -n com.steinwurf.adbjoinwifi/.MainActivity \
    -e ssid "$SSID" -e password_type "$PASSWORD_TYPE" -e password "$PASSWORD"
  if [ $? -eq 0 ]; then
    echo "Wi-Fi connection command sent to $DEVICE"
  else
    echo "Failed to send Wi-Fi command to $DEVICE"
  fi
done
