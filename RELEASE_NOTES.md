# Release Notes

## Release Notes - v0.0.2

Version 0.0.2 is a major release introducing 10 comprehensive categories of native device intelligence, anti-fraud security inspection, DRM streaming validation, thermal management, biometric hardware, display capabilities, audio stream levels, and regional accessibility settings.

### 🌟 What's New in v0.0.2

*   **🛡️ Security, Developer Mode & Anti-Fraud Suite (`SecurityInfo`):**
    *   Developer options toggle detection (`isDeveloperMode`).
    *   USB debugging (`isAdbEnabled`) and Android 11+ Wireless ADB (`isWirelessDebuggingEnabled`).
    *   USB cable hardware connection status (`isUsbConnected`).
    *   Fake GPS and mock location provider detection (`isMockLocation`).
    *   Stay-awake while charging detection (`isStayAwake`).
    *   USB app verification check (`isVerificationOfAppsOverUsb`).
    *   Device lock screen security (PIN, pattern, password, biometric) (`isDeviceSecure`).
    *   Active native debugger detection (`isDebuggerAttached`).
    *   Consolidated `isCompromised` helper flag.
*   **🌡️ Thermal & Power Management (`ThermalInfo`):**
    *   Thermal throttling levels (`NONE`, `LIGHT`, `MODERATE`, `SEVERE`, `CRITICAL`, `EMERGENCY`, `SHUTDOWN`).
    *   `isThrottling` helper for adaptive rendering and frame rate downscaling.
    *   System Low Power / Battery Saver mode detection (`isPowerSaveMode`).
    *   Android Doze / Deep Sleep idle mode state (`isDeviceIdleMode`).
*   **🎬 OTT DRM Certification (`DrmInfo`):**
    *   Widevine security level (`L1` vs `L3`), vendor, version, and hardware system ID.
    *   `isHdCapable` validation helper for Full HD (1080p) & 4K UHD streaming.
*   **🔐 Biometric Hardware & Enrollment (`BiometricInfo`):**
    *   Hardware detection for Fingerprint / Touch ID, Face ID, Iris, and Optic ID.
    *   User biometric enrollment verification (`isEnrolled`).
*   **🧭 Hardware Sensors Inventory (`SensorsInfo`):**
    *   Sensor flags: accelerometer, gyroscope, magnetometer, barometer, proximity, ambient light, and step counter.
    *   Total sensor count and hardware sensor names catalog.
*   **⚡ Live Hardware Signals (`LiveHardwareInfo`):**
    *   Display interactive screen state (`isScreenOn`).
    *   Wi-Fi radio toggle state (`isWifiEnabled`).
    *   Active cellular or VoIP call status (`isCallActive`).
    *   Headphones route status (3.5mm jack, USB-C DAC, Bluetooth A2DP/LE) (`isHeadphonesConnected`).
    *   Cellular SIM slots count (`simSlotCount`) and `isDualSim` helper.
*   **🖥️ Display HDR, Colors & Refresh Rates (`DisplayCapabilitiesInfo`):**
    *   HDR format detection (`HDR10`, `HDR10_PLUS`, `DOLBY_VISION`, `HLG`).
    *   Wide color gamut (DCI-P3) panel detection (`isWideColorGamut`).
    *   Display refresh rates list (`supportedRefreshRates`, e.g. 60Hz, 90Hz, 120Hz).
    *   Display screen brightness index (0–255) and adaptive auto-brightness state.
*   **🧰 Onboard Radios & Peripherals (`PeripheralsInfo`):**
    *   NFC chip presence and enabled state.
    *   Bluetooth radio presence and enabled state.
    *   Camera lens count (front, back, total) and LED flashlight detection.
    *   Vibrator motor and advanced haptic amplitude modulation.
*   **🔊 Audio Streams & Volume Controls (`AudioVolumeInfo`):**
    *   Volume levels and maximum steps for Media, Ringtone, Call, Alarm, and Notification streams.
    *   Normalized media volume percentage helper (`mediaVolumePercentage`).
    *   Hardware microphone mute detection and Bluetooth A2DP audio route.
*   **🌐 Regional, Theme & Accessibility (`LocaleThemeInfo`):**
    *   Timezone identifier, display name, and formatted UTC offset (`+05:30`).
    *   User preferred language order list.
    *   24-hour vs 12-hour clock format.
    *   Accessibility font scale multiplier, TalkBack / VoiceOver screen reader detection, and OS dark mode status.
*   **📱 "About Phone" Build Details (`DeviceInfo`):**
    *   Android security patch date, OS kernel release, baseband modem firmware, bootloader, supported ABIs, and human-readable system uptime.
*   **🔄 Aggregated System Snapshot (`SystemInfo`):**
    *   Single, optimized platform call via `AdvancedDeviceInfo.getSystemInfo()` fetching 100+ native hardware and security metrics.

### 📝 Example Usage

```dart
import 'package:advanced_device_info/advanced_device_info.dart';

void main() async {
  // Fetch unified system snapshot
  final SystemInfo sys = await AdvancedDeviceInfo.getSystemInfo();

  print('Device: ${sys.deviceInfo.manufacturer} ${sys.deviceInfo.model}');
  print('RAM: ${sys.memoryInfo.formattedUsedRam} / ${sys.memoryInfo.formattedTotalRam}');
  print('Storage: ${sys.storageInfo.formattedUsedStorage} / ${sys.storageInfo.formattedTotalStorage}');
  print('Security: ${sys.securityInfo.isCompromised ? "COMPROMISED" : "CLEAN"}');
  print('Widevine DRM: ${sys.drmInfo.widevineSecurityLevel}');
}
```

---

## Release Notes - v0.0.1

Initial release of `advanced_device_info` providing core device, storage, memory, CPU, and screen metrics:
*   **📱 Device Info:** Basic brand, manufacturer, model, OS version, emulator status.
*   **💾 Storage Info:** Total, free, and used storage bytes with usage percentages.
*   **🧠 RAM Memory Info:** Total, available, and used system RAM bytes.
*   **⚡ CPU Info:** CPU architecture and core count.
*   **🖥️ Screen Info:** Width, height, density scale, and refresh rate in Hz.
*   **🔄 Unified System Info:** Aggregate core metrics in a single native call.
