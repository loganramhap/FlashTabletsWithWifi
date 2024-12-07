@echo off
:: Determine the platform (Windows or macOS)
setlocal enabledelayedexpansion
for /f %%i in ('ver') do set VERSION=%%i
echo %VERSION% | find "Windows" >nul
if %errorlevel% equ 0 goto :WINDOWS

:: If not Windows, assume macOS or Linux and switch to Bash
bash -c '
#!/bin/bash
# Prompt for inputs
read -p "Enter the Wi-Fi SSID: " SSID
read -p "Enter the Wi-Fi Password: " PASSWORD
read -p "Enter the password type (default \"WPA\"): " PASSWORD_TYPE
PASSWORD_TYPE=${PASSWORD_TYPE:-WPA}

# Get the list of connected devices
DEVICES=$(adb devices | awk '\''NR>1 && /device$/ {print $1}'\'')

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
'
exit /b

:WINDOWS
:: Windows Batch Section

:: Prompt for inputs
set /p SSID="Enter the Wi-Fi SSID: "
set /p PASSWORD="Enter the Wi-Fi Password: "
set /p PASSWORD_TYPE="Enter the password type (default 'WPA'): "
if "%PASSWORD_TYPE%"=="" set PASSWORD_TYPE=WPA

:: Get connected devices
for /f "skip=1 tokens=1,2 delims=	" %%A in ('adb devices') do (
    if "%%B"=="device" (
        set DEVICE=%%A
        echo Connecting to Wi-Fi on device %%A...
        adb -s %%A shell am start -n com.steinwurf.adbjoinwifi/.MainActivity -e ssid "%SSID%" -e password_type "%PASSWORD_TYPE%" -e password "%PASSWORD%"
        if !errorlevel! equ 0 (
            echo Wi-Fi connection command sent to %%A
        ) else (
            echo Failed to send Wi-Fi command to %%A
        )
    )
)
