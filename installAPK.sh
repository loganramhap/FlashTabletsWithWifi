#!/bin/bash

# Path to the APK file you want to install
APK_PATH="/Users/loganramhap/Documents/GitHub/FlashTabletsWithWifi/adb-join-wifi.apk"

# Get the list of connected devices
devices=$(adb devices | grep -w "device" | awk '{print $1}')

# Check if devices are connected
if [ -z "$devices" ]; then
    echo "No devices connected."
    exit 1
fi

# Loop through each connected device
for device in $devices; do
    echo "Installing APK on device: $device"
    
    # Install the APK on the device
    adb -s $device install "$APK_PATH"
    
    # Check if the installation was successful
    if [ $? -eq 0 ]; then
        echo "APK installed successfully on device $device."
    else
        echo "Failed to install APK on device $device."
    fi
done
