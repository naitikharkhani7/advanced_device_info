# advanced_device_info_example

A showcase application demonstrating the capabilities of the **`advanced_device_info`** Flutter plugin across Android and iOS.

## 📱 Features Demonstrated

This example app renders a production-grade diagnostic dashboard presenting:

- **🛡️ Security & Anti-Fraud:** Root & jailbreak detection, USB/Wireless ADB status, developer mode, mock location/GPS spoofing, USB cable connection, secure keyguard check, and native debugger attachment.
- **🌡️ Thermal Throttling & Power:** Real-time thermal throttling status (`NONE`, `LIGHT`, `SEVERE`, `CRITICAL`), battery saver status, and device idle/doze mode.
- **🎬 OTT DRM Certification:** Widevine security levels (`L1` vs `L3`), DRM vendor, version, system ID, and HD/4K playback readiness.
- **🔐 Biometric Hardware & Enrollment:** Hardware detection and enrollment status for Fingerprint / Touch ID, Face ID, Iris, and Optic ID.
- **🧭 Hardware Sensors Inventory:** Detailed enumeration of onboard hardware sensors (accelerometer, gyroscope, magnetometer, barometer, proximity, ambient light, and step counter).
- **⚡ Live Hardware Signals:** Screen interactive status, hardware Wi-Fi adapter toggle, active phone/VoIP calls, headphone route detection (wired/Bluetooth A2DP), and physical SIM slots count.
- **🖥️ Display & HDR:** HDR format detection (`HDR10`, `Dolby Vision`, `HLG`), DCI-P3 wide color gamut, supported display refresh rate modes (e.g., 60Hz, 90Hz, 120Hz), and auto-brightness state.
- **🧰 Radios & Peripherals:** NFC availability and enabled state, Bluetooth radio adapter, camera lens inventory (front & rear), LED flashlight/torch, and vibrator motor with haptic amplitude control.
- **🔊 Audio Streams & Volume:** Real-time volume indices and maximum steps for Media, Ringtone, In-Call voice, Alarm, and Notification streams, plus microphone mute and Bluetooth A2DP audio route.
- **🌐 Regional, Theme & Accessibility:** System timezone ID, UTC offset, user preferred language list, 24-hour vs 12-hour clock, accessibility font scale multiplier, TalkBack / VoiceOver screen reader status, and dark mode.
- **🔋 Battery & Power Health:** Real-time percentage, charging state, power source (AC, USB, Wireless), battery health, and battery temperature in °C and °F.
- **📶 Network Connectivity:** Internet connectivity state, connection transport (Wi-Fi, Cellular, Ethernet), and deep active VPN tunnel detection.
- **💾 Storage & 🧠 Memory:** Total, free, and used disk storage and RAM bytes with human-readable formatters.
- **📱 "About Phone" Build Details:** Android security patch date, OS kernel release, modem radio firmware, bootloader, CPU ABIs, and human-readable system uptime.

## 🚀 Running the Example

### Android
Ensure an Android device or emulator is connected:
```bash
flutter run -d android
```

### iOS
Ensure an iOS simulator or physical device is connected:
```bash
flutter run -d ios
```

## 📖 Code Overview

The entire dashboard is implemented in [`lib/main.dart`](lib/main.dart) using a single, efficient native call to:

```dart
final SystemInfo sys = await AdvancedDeviceInfo.getSystemInfo();
```

All metrics are reactive and can be re-fetched at any time using the AppBar refresh action or pull-to-refresh.
