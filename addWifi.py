import subprocess

def get_connected_devices():
    """Get a list of connected Android devices."""
    try:
        result = subprocess.run(['adb', 'devices'], capture_output=True, text=True)
        lines = result.stdout.strip().split("\n")[1:]  # Skip the header line
        devices = [line.split("\t")[0] for line in lines if "device" in line]
        return devices
    except Exception as e:
        print(f"Error getting connected devices: {e}")
        return []

def connect_to_wifi(devices, ssid, password, password_type="WPA"):
    """Run the ADB command to connect to Wi-Fi on each device."""
    for device in devices:
        print(f"Connecting to Wi-Fi on device {device}...")
        try:
            command = [
                'adb', '-s', device, 'shell', 'am', 'start', '-n', 
                'com.steinwurf.adbjoinwifi/.MainActivity',
                '-e', 'ssid', ssid,
                '-e', 'password_type', password_type,
                '-e', 'password', password
            ]
            subprocess.run(command, check=True)
            print(f"Wi-Fi connection command sent to {device}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to send Wi-Fi command to {device}: {e}")

if __name__ == "__main__":
    ssid = input("Enter the Wi-Fi SSID: ").strip().replace(' ', '\\ ').replace("'",r"\'")
    
    password = input("Enter the Wi-Fi Password: ").strip().replace(' ', '\\ ')
    password_type = input("Enter the password type (default 'WPA'): ").strip() or "WPA"
    
    devices = get_connected_devices()
    if devices:
        print(f"Found {len(devices)} device(s): {', '.join(devices)}")
        connect_to_wifi(devices, ssid, password, password_type)
    else:
        print("No devices connected.")
