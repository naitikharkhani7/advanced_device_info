# advanced_device_info

[![pub package](https://img.shields.io/pub/v/advanced_device_info.svg)](https://pub.dev/packages/advanced_device_info)
[![Flutter](https://img.shields.io/badge/Flutter-3.3%2B-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green.svg)](https://pub.dev/packages/advanced_device_info)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Pub Points](https://img.shields.io/pub/points/advanced_device_info)](https://pub.dev/packages/advanced_device_info/score)

A production-ready Flutter plugin for retrieving comprehensive system-level device, hardware, battery, network, and security/anti-fraud inspection metrics on Android and iOS using native platform APIs.

---

# ✨ Features

## 🛡️ Security & Integrity (Fintech / Anti-Fraud)
- **Root Detection** (Android `su` binary, test-keys, Magisk detection)
- **Jailbreak Detection** (iOS Cydia, substrate, sandbox integrity escape)
- **Developer Options Detection** (Check if Developer Mode is enabled in settings)
- **USB Debugging / ADB Detection** (Check if ADB is active)
- **USB Cable Connection Status** (Detect if phone is plugged into a USB cable/computer)
- **Screen Lock Security** (Check if PIN, Pattern, Password, or Biometrics are set)
- **Native Debugger Detection** (Check if a debugger is actively attached)
- **`isCompromised` Convenience Flag**

---

## 🔋 Battery & Power Information
- **Battery Level** (0% to 100%)
- **Charging State** (`charging`, `discharging`, `full`, `notCharging`)
- **Power Source** (`ac`, `usb`, `wireless`, `none`)
- **Battery Health** (`good`, `overheat`, `dead`, `over_voltage`, etc.)
- **Battery Temperature** in °Celsius
- **Low Power Mode / Battery Saver** status

---

## 📶 Network & Connectivity
- **Active Internet State** (Connected / Offline)
- **Connection Type** (`wifi`, `cellular`, `ethernet`, `vpn`, `none`)
- **VPN Detection** (Detect active VPN tunnels and proxy configurations)

---

## 📱 Device Information
- Device Name
- Manufacturer
- Brand
- Model
- Build ID, Display, Fingerprint, Hardware
- SDK Version & OS Release
- Emulator / Simulator Detection

---

## 💾 Storage Information
- Total, Used, and Free Storage in Bytes
- Usage Percentage
- **Convenience Getters**: `totalStorageGB`, `usedStorageGB`, `freeStorageGB`, `formattedUsedStorage`, etc.
- `isLowStorage(thresholdPercent: 90)`

---

## 🧠 Memory (RAM) Information
- Total, Used, and Available RAM in Bytes
- Memory Usage Percentage
- **Convenience Getters**: `totalRamGB`, `usedRamGB`, `availableRamGB`, `formattedTotalRam`, etc.
- `isLowMemory(thresholdPercent: 85)`

---

## ⚡ CPU & 🖥 Screen Information
- Architecture (`arm64`, `x86_64`, etc.) and CPU Core Count
- Physical Width & Height in Pixels
- Screen Scale / Density Scale
- Refresh Rate in Hz (e.g. 60Hz, 90Hz, 120Hz)

---

# 📦 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  advanced_device_info: ^0.0.1
```

Install packages:

```bash
flutter pub get
```

---

# ✅ Platform Support

| Platform | Support |
|----------|---------|
| Android | ✅ |
| iOS | ✅ |
| macOS | 🚧 Planned |
| Windows | 🚧 Planned |
| Linux | 🚧 Planned |
| Web | ❌ |

---

# 🚀 Quick Start

```dart
import 'package:advanced_device_info/advanced_device_info.dart';

// Get all system, battery, security, and hardware metrics at once:
final SystemInfo info = await AdvancedDeviceInfo.getSystemInfo();

// 1. Security & Anti-Fraud Checks (Great for Banking / Payment apps)
if (info.securityInfo.isDeveloperMode) {
  print("Developer Mode is ON!");
}
if (info.securityInfo.isAdbEnabled) {
  print("USB Debugging is Active!");
}
if (info.securityInfo.isUsbConnected) {
  print("USB Cable is Connected!");
}
if (info.securityInfo.isCompromised) {
  print("Device is Rooted, Jailbroken, or Debugger attached!");
}

// 2. Battery Information
print("Battery Level: ${info.batteryInfo.batteryLevel}%");
print("Charging: ${info.batteryInfo.isCharging}");
print("Power Source: ${info.batteryInfo.powerSource}");
print("Temp: ${info.batteryInfo.batteryTemperature}°C");

// 3. Network & VPN
print("Online: ${info.networkInfo.isConnected}");
print("Type: ${info.networkInfo.connectionType}");
print("VPN Active: ${info.networkInfo.isVpnActive}");

// 4. Storage & RAM Convenience Getters
print("Used Storage: ${info.storageInfo.formattedUsedStorage}"); // e.g. "54.2 GB"
print("Available RAM: ${info.memoryInfo.formattedAvailableRam}"); // e.g. "3.5 GB"
```

---

# 📚 API Reference

| Method | Description |
|---------|-------------|
| `getSystemInfo()` | Returns aggregated system, hardware, battery, and security metrics |
| `getSecurityInfo()` | Returns Root, Jailbreak, Developer Mode, ADB, USB cable, and Lock screen status |
| `getBatteryInfo()` | Returns Battery level, charging state, power source, temperature, and battery saver mode |
| `getNetworkInfo()` | Returns Connectivity state, network transport type, and active VPN detection |
| `getDeviceInfo()` | Returns Device metadata, manufacturer, model, and emulator flag |
| `getStorageInfo()` | Returns Storage capacity, used/free bytes, and GB/MB formatters |
| `getMemoryInfo()` | Returns RAM capacity, used/free bytes, and GB/MB formatters |
| `getCpuInfo()` | Returns CPU architecture and core count |
| `getScreenInfo()` | Returns Display dimensions, scale factor, and refresh rate in Hz |

---

# 📄 Example Output

```text
Device Name          : Pixel 9 Pro
Manufacturer         : Google
Model                : Pixel 9 Pro
Brand                : google
Is Emulator          : false

-- Security --
Developer Mode       : false
USB Debugging (ADB)  : false
USB Cable Connected  : false
Root / Jailbreak     : false
Passcode Secured     : true

-- Battery --
Battery Level        : 85%
Charging             : false
Power Source         : none
Temperature          : 31.5°C
Battery Saver        : false

-- Network --
Connected            : true
Type                 : wifi
VPN Active           : false

-- Storage & Memory --
Storage              : 128.0 GB (Used: 54.2 GB, Free: 73.8 GB)
RAM                  : 8.0 GB (Used: 4.5 GB, Free: 3.5 GB)

-- CPU & Screen --
CPU Cores            : 8 Cores (arm64)
Display              : 1344 x 2992 @ 120 Hz
```

---

# 📸 Screenshots

<p align="center">
  <img src="screenshots/dashboard.png" width="300" alt="Dashboard">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="screenshots/storage.png" width="300" alt="Storage Info">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="screenshots/memory.png" width="300" alt="Memory Info">
</p>

---

# 🤝 Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to check the [issues page](https://github.com/naitikharkhani7/advanced_device_info/issues).

---

# 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.