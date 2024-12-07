@echo off
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
