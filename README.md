# advanced_device_info

[![pub package](https://img.shields.io/pub/v/advanced_device_info.svg)](https://pub.dev/packages/advanced_device_info)
[![Flutter](https://img.shields.io/badge/Flutter-3.3%2B-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green.svg)](https://pub.dev/packages/advanced_device_info)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Pub Points](https://img.shields.io/pub/points/advanced_device_info)](https://pub.dev/packages/advanced_device_info/score)

The ultimate, all-in-one Flutter device intelligence and diagnostics plugin. Retrieve **100+ native hardware specs, live peripheral states, anti-fraud & security indicators, DRM certifications, biometric hardware, thermal throttling, display HDR profiles, audio stream volumes, and accessibility settings** on Android and iOS.

Replaces the need for 5+ fragmented packages (`device_info_plus`, `battery_plus`, `connectivity_plus`, root checkers, audio volume managers, and sensor libraries) into a single, unified, lightweight library with **zero dangerous permissions**.

---

## 📑 Table of Contents
- [⚡ Why `advanced_device_info`? (Comparison Matrix)](#-why-advanced_device_info)
- [✨ Exhaustive Feature Breakdown](#-exhaustive-feature-breakdown)
  - [1. 🛡️ Security, Developer Mode & Anti-Fraud Suite](#1-️-security-developer-mode--anti-fraud-suite)
  - [2. 🌡️ Thermal & Power Management](#2-️-thermal--power-management)
  - [3. 🎬 DRM & Video Streaming Certification](#3--drm--video-streaming-certification)
  - [4. 🔐 Biometric Hardware & Enrollment](#4--biometric-hardware--enrollment)
  - [5. 🧭 Hardware Sensors Inventory](#5--hardware-sensors-inventory)
  - [6. ⚡ Live Hardware & Peripheral Signals](#6--live-hardware--peripheral-signals)
  - [7. 🖥️ Display HDR, Colors & Refresh Rates](#7-️-display-hdr-colors--refresh-rates)
  - [8. 🧰 Onboard Peripherals & Radios](#8--onboard-peripherals--radios)
  - [9. 🔊 Audio Streams & Volume Controls](#9--audio-streams--volume-controls)
  - [10. 🌐 Regional, Theme & Accessibility](#10--regional-theme--accessibility)
  - [11. 🔋 Battery & Power Health](#11--battery--power-health)
  - [12. 📶 Network & VPN Tunnel Detection](#12--network--vpn-tunnel-detection)
  - [13. 📱 "About Phone" System Build Info](#13--about-phone-system-build-info)
  - [14. 💾 Storage & 🧠 RAM Memory Details](#14--storage---ram-memory-details)
- [📦 Installation & Setup](#-installation--setup)
- [🚀 Real-World Code Recipes](#-real-world-code-recipes)
  - [Recipe 1: Full System Diagnostics in 1 Line](#recipe-1-full-system-diagnostics-in-1-line)
  - [Recipe 2: FinTech / Banking Fraud Shield](#recipe-2-fintech--banking-fraud-shield)
  - [Recipe 3: OTT Streaming & DRM Validation](#recipe-3-ott-streaming--drm-validation)
  - [Recipe 4: Adaptive 120Hz Gaming & Thermal Throttling](#recipe-4-adaptive-120hz-gaming--thermal-throttling)
  - [Recipe 5: Audio Volume Level Inspector](#recipe-5-audio-volume-level-inspector)
  - [Recipe 6: Accessibility & Theme Synchronization](#recipe-6-accessibility--theme-synchronization)
- [📚 Comprehensive API & Model Reference](#-comprehensive-api--model-reference)
- [🔒 Zero-Permission Architecture](#-zero-permission-architecture)
- [🤝 Contributing & Support](#-contributing--support)
- [📝 License](#-license)

---

## ⚡ Why `advanced_device_info`?

| Capability | Standard `device_info_plus` | `advanced_device_info` |
|---|:---:|:---:|
| Basic Device Model, Brand, Manufacturer | ✅ | ✅ |
| Storage & RAM (Exact Bytes, GB, Free, Used, Percent) | ❌ | ✅ |
| Battery Health, Temp (°C), Source & Battery Saver | ❌ | ✅ |
| Active VPN Tunnel Detection (Interface & Proxy analysis) | ❌ | ✅ |
| Security: Root & Jailbreak Detection | ❌ | ✅ |
| Security: Developer Mode, ADB & Wireless ADB Detection | ❌ | ✅ |
| Security: Fake GPS / Mock Location Provider Detection | ❌ | ✅ |
| Security: USB Cable Connection State | ❌ | ✅ |
| Security: Screen Lock & Keyguard Verification | ❌ | ✅ |
| Security: Native Debugger (ptrace / lldb) Detection | ❌ | ✅ |
| DRM: Widevine Security Level (`L1` vs `L3`) & System ID | ❌ | ✅ |
| Biometrics: Fingerprint, Face ID, Iris Hardware & Enrollment | ❌ | ✅ |
| Sensors: Complete Hardware Sensors Catalog (24+ sensors) | ❌ | ✅ |
| Thermal: Throttling Status (`NONE` to `CRITICAL`) & Doze Mode | ❌ | ✅ |
| Display: HDR Formats (`HDR10`, `Dolby Vision`), DCI-P3 Gamut & 120Hz Modes | ❌ | ✅ |
| Peripherals: NFC, Bluetooth, Torch, Camera Counts & Haptics | ❌ | ✅ |
| Audio: Stream Volumes (Media, Ring, Call, Alarm) & Mic Mute | ❌ | ✅ |
| Regional: Timezone ID, UTC Offset, 24h Clock & Font Scale | ❌ | ✅ |
| Accessibility: TalkBack & VoiceOver Screen Reader Detection | ❌ | ✅ |
| Live Signals: Screen Interactive, Wi-Fi Radio, In-Call, SIM Slots | ❌ | ✅ |
| Single-Call Aggregated Snapshot (`getSystemInfo()`) | ❌ | ✅ |

---

## ✨ Exhaustive Feature Breakdown

### 1. 🛡️ Security, Developer Mode & Anti-Fraud Suite
Designed specifically for banking, crypto wallets, payment apps, and gaming anti-cheat engines:
- **Developer Options** (`isDeveloperMode`) - Detects if Android Developer Options are enabled in system settings.
- **USB Debugging (ADB)** (`isAdbEnabled`) - Detects if ADB debugging over USB is currently enabled.
- **Wireless Debugging (Wi-Fi ADB)** (`isWirelessDebuggingEnabled`) - Detects Android 11+ wireless ADB debugging.
- **USB Cable Connection State** (`isUsbConnected`) - Detects if device is currently plugged into a USB host computer or charger.
- **Fake GPS / Mock Location** (`isMockLocation`) - Identifies simulated GPS locations or installed mock location providers.
- **Stay Awake on Charge** (`isStayAwake`) - Detects developer mode setting that prevents screen sleep while charging.
- **USB App Package Verification** (`isVerificationOfAppsOverUsb`) - Checks if package verification over ADB is enforced.
- **Root & Jailbreak Detection** (`isRooted`, `isJailbroken`) - Deep inspection across 14 known `su` binary paths, `test-keys` build signatures, Superuser apps, Magisk mount points, and iOS sandbox integrity.
- **Screen Lock Security** (`isDeviceSecure`) - Checks if user has configured a secure lock screen (PIN, Pattern, Password, or Biometrics).
- **Native Debugger Attachment** (`isDebuggerAttached`) - Detects active debuggers (`ptrace`, LLDB, Java Debug Wire Protocol).
- **`isCompromised` Convenience Flag** - Fast evaluation combining root, jailbreak, debugger, and mock GPS checks into a single boolean.

---

### 2. 🌡️ Thermal & Power Management
Essential for games, media rendering, camera processing, and heavy machine learning workloads:
- **Thermal Throttling State** (`thermalStatus`) - Android 10+ and iOS thermal states:
  - `NONE` / `NOMINAL` - Device operating at normal temperatures.
  - `LIGHT` / `FAIR` - Minor thermal elevation, light throttling.
  - `MODERATE` - Moderate thermal throttling, fans or clock adjustments initiated.
  - `SEVERE` / `SERIOUS` - Significant thermal throttling, performance heavily throttled.
  - `CRITICAL` - Critical temperature threshold reached.
  - `EMERGENCY` / `SHUTDOWN` - Thermal emergency shutdown imminent.
- **Throttling Warning Helper** (`isThrottling`) - Quick boolean check for moderate or critical thermal conditions.
- **Battery Saver Mode** (`isPowerSaveMode`) - Checks if system low-power mode is currently active.
- **Device Doze / Idle State** (`isDeviceIdleMode`) - Detects Android Doze mode (device stationary with screen off).

---

### 3. 🎬 DRM & Video Streaming Certification
Verify media playback readiness for OTT platforms (Netflix, Prime Video, Disney+, Apple TV+):
- **Widevine Security Level** (`widevineSecurityLevel`) - Returns `L1` (hardware-backed secure decryption), `L2`, or `L3` (software decryption).
- **HD / 4K Streaming Certification** (`isHdCapable`) - Confirms whether device is certified for 1080p FHD and 4K UHD streaming.
- **DRM Vendor & Version** (`widevineVendor`, `widevineVersion`) - DRM library information (e.g. Google, FairPlay).
- **Crypto System ID** (`systemId`) - Hardware cryptographic system identifier.

---

### 4. 🔐 Biometric Hardware & Enrollment
- **Hardware Presence** (`hasBiometrics`) - Detects if biometric hardware exists on the device.
- **Enrollment State** (`isEnrolled`) - Confirms if the user has actively registered biometric credentials.
- **Supported Modalities** (`supportedTypes`) - List of available biometric types (`fingerprint`, `face`, `iris`, `optic`).
- **Modalities Getters** - `hasFingerprint`, `hasFaceId`, `hasIris`.

---

### 5. 🧭 Hardware Sensors Inventory
Comprehensive enumeration of onboard sensor chips:
- **Sensor Detection Flags**:
  - `hasAccelerometer` (3-axis acceleration)
  - `hasGyroscope` (angular velocity / rotation)
  - `hasMagnetometer` (digital compass / magnetic field)
  - `hasBarometer` (atmospheric pressure & altimeter)
  - `hasProximity` (object distance sensor)
  - `hasLight` (ambient illumination sensor)
  - `hasStepCounter` (hardware pedometer)
- **Total Sensors Count** (`totalSensorCount`) - Total count of physical sensors detected on device (e.g. 24+ on modern phones).
- **Sensor Names Catalog** (`sensorNames`) - List containing every registered hardware sensor name.

---

### 6. ⚡ Live Hardware & Peripheral Signals
Real-time hardware status without polling:
- **Screen Interactive State** (`isScreenOn`) - Checks if display panel is turned on and interactive.
- **Wi-Fi Radio Adapter** (`isWifiEnabled`) - Hardware Wi-Fi radio toggle state (independent of whether connected to an AP).
- **Active Phone / VoIP Call** (`isCallActive`) - Real-time call or communication session detection (cellular or VoIP).
- **Headphone / Audio Routing** (`isHeadphonesConnected`) - Wired 3.5mm headsets, USB-C DACs, Bluetooth A2DP, or LE audio devices.
- **Cellular SIM Slot Count** (`simSlotCount`) - Hardware modem count (1 for Single SIM, 2 for Dual SIM).
- **Dual SIM Helper** (`isDualSim`) - Quick boolean check if device supports Dual SIM.

---

### 7. 🖥️ Display HDR, Colors & Refresh Rates
- **HDR Display Playback** (`isHdrSupported`) - High Dynamic Range video capability.
- **Supported HDR Formats** (`supportedHdrTypes`) - `HDR10`, `HDR10_PLUS`, `DOLBY_VISION`, `HLG`.
- **Wide Color Gamut** (`isWideColorGamut`) - DCI-P3 color gamut display panel detection.
- **Supported Refresh Rates** (`supportedRefreshRates`) - All display refresh frequencies supported by the panel (e.g., `[45Hz, 48Hz, 50Hz, 60Hz, 90Hz, 120Hz]`).
- **High Refresh Rate Helper** (`supportsHighRefreshRate`) - True if display supports > 60Hz.
- **Screen Brightness & Auto-Mode** (`screenBrightness`, `isAutoBrightnessEnabled`) - Display brightness level (0–255) and adaptive toggle state.

---

### 8. 🧰 Onboard Peripherals & Radios
- **NFC Hardware** (`isNfcAvailable`, `isNfcEnabled`) - NFC chip availability and active toggle state.
- **Bluetooth Radio** (`isBluetoothAvailable`, `isBluetoothEnabled`) - Bluetooth adapter presence and state.
- **Camera Flashlight / Torch** (`hasFlashlight`) - Built-in LED flash availability.
- **Camera Lenses Count** (`cameraCount`, `frontCameraCount`, `backCameraCount`) - Front and rear physical camera counts.
- **Haptic Engine** (`hasVibrator`, `hasAmplitudeControl`) - Vibration motor presence and advanced amplitude modulation.

---

### 9. 🔊 Audio Streams & Volume Controls
- **Audio Stream Volumes**:
  - `mediaVolume` & `maxMediaVolume` (Music, videos, games)
  - `ringVolume` & `maxRingVolume` (Incoming call ringtones)
  - `callVolume` & `maxCallVolume` (In-call voice volume)
  - `alarmVolume` & `maxAlarmVolume` (Alarm clock sound)
  - `notificationVolume` & `maxNotificationVolume` (System notifications)
- **Volume Percentage** (`mediaVolumePercentage`) - Normalized 0.0 to 100.0% volume.
- **Hardware Microphone Mute** (`isMicrophoneMute`) - Hardware/system microphone mute state.
- **Bluetooth Audio Profile** (`isBluetoothA2dpOn`) - Active A2DP high-fidelity audio stream.

---

### 10. 🌐 Regional, Theme & Accessibility
- **Timezone Identifier & Display Name** (`timezoneId`, `timezoneDisplayName`, e.g. `Asia/Kolkata`, `India Standard Time`).
- **Formatted UTC Offset** (`formattedUtcOffset`, e.g. `+05:30`, `-04:00`).
- **Timezone Offset in Seconds** (`timezoneOffsetSeconds`).
- **Preferred System Languages** (`preferredLanguages`, e.g. `["en-US", "hi-IN"]`).
- **24-Hour Clock Format** (`is24HourFormat`) - User preference for 12h vs 24h clock.
- **Font Scale Multiplier** (`fontScale`, e.g. `0.90x`, `1.15x`) - System accessibility text zoom.
- **Screen Reader State** (`isScreenReaderActive`) - TalkBack (Android) or VoiceOver (iOS) active status.
- **Dark Mode Theme** (`isDarkMode`) - OS dark mode / night theme detection.

---

### 11. 🔋 Battery & Power Health
- **Battery Level** (0% to 100%).
- **Charging State** (`charging`, `discharging`, `full`, `notCharging`).
- **Power Source** (`ac`, `usb`, `wireless`, `dock`, `none`).
- **Battery Health** (`good`, `overheat`, `dead`, `over_voltage`, `cold`).
- **Battery Temperature** in °Celsius and °Fahrenheit (`batteryTemperature`, `temperatureFahrenheit`).
- **Battery Helpers**: `isLow` (<= 20%), `isFull` (>= 95%).

---

### 12. 📶 Network & VPN Tunnel Detection
- **Active Internet State** (`isConnected`, `isOffline`).
- **Connection Transport Type** (`wifi`, `cellular`, `ethernet`, `bluetooth`, `vpn`, `none`).
- **VPN Tunnel Detection** (`isVpnActive`) - Deep inspection across `tun`, `ppp`, `p2p`, `tap`, `ipsec` virtual interfaces and system proxy tables.
- **Transport Helpers**: `isWifi`, `isCellular`.

---

### 13. 📱 "About Phone" System Build Info
- **Branding**: Device Name, Manufacturer, Brand, Model, Hardware Board.
- **OS Information**: Release, Codename, Incremental build number.
- **Security Patch**: Android Security Patch date (`securityPatch`, e.g. `2024-05-01`).
- **Kernel Version**: OS Kernel release (`kernelVersion`, e.g. `Linux 5.15.78`).
- **Radio Firmware**: Baseband / Modem version (`radioVersion`).
- **Bootloader**: Bootloader identifier (`bootloader`).
- **CPU Architectures**: Supported ABIs (`supportedAbis`, e.g. `arm64-v8a`).
- **System Uptime**: Formatted uptime string (`formattedUptime`, e.g. `"2d 4h 15m"`).
- **Emulator / Simulator**: Hardware and fingerprint heuristic verification.

---

### 14. 💾 Storage & 🧠 RAM Memory Details
- Exact byte values: `totalStorage`, `usedStorage`, `freeStorage`, `totalRam`, `usedRam`, `availableRam`.
- Percentage calculations: `storageInfo.usagePercentage`, `memoryInfo.usagePercentage`.
- Convenience GB / MB getters: `totalStorageGB`, `usedStorageGB`, `freeStorageGB`, `totalRamGB`, `availableRamGB`.
- Formatted strings: `formattedUsedStorage` (e.g. `"54.2 GB"`), `formattedAvailableRam` (e.g. `"3.5 GB"`).
- Byte formatting extension: `1073741824.toReadableBytes()` -> `"1.0 GB"`.
- Warning helpers: `isLowStorage(thresholdPercent: 90)`, `isLowMemory(thresholdPercent: 85)`.

---

## 📦 Installation & Setup

Add `advanced_device_info` to your `pubspec.yaml`:

```yaml
dependencies:
  advanced_device_info: ^0.0.2
```

Or install via Flutter CLI:

```bash
flutter pub add advanced_device_info
```

### Platform Compatibility
| Platform | Supported | Minimum OS Version |
|---|:---:|---|
| **Android** | ✅ | Android 5.0+ (API 21+) |
| **iOS** | ✅ | iOS 12.0+ |
| **macOS** | 🚧 Planned | macOS 11.0+ |
| **Windows** | 🚧 Planned | Windows 10+ |
| **Linux** | 🚧 Planned | Ubuntu 20.04+ |

---

## 🚀 Real-World Code Recipes

### Recipe 1: Full System Diagnostics in 1 Line
Fetch every hardware, security, sensor, and battery metric in a single optimized native call:

```dart
import 'package:advanced_device_info/advanced_device_info.dart';

void runFullDiagnostics() async {
  final SystemInfo sys = await AdvancedDeviceInfo.getSystemInfo();

  // About Phone
  print('Device: ${sys.deviceInfo.manufacturer} ${sys.deviceInfo.model}');
  print('Security Patch: ${sys.deviceInfo.securityPatch}');
  print('Kernel: ${sys.deviceInfo.kernelVersion}');
  print('Uptime: ${sys.deviceInfo.formattedUptime}');

  // Storage & RAM
  print('Storage: ${sys.storageInfo.formattedUsedStorage} / ${sys.storageInfo.formattedTotalStorage}');
  print('RAM: ${sys.memoryInfo.formattedUsedRam} / ${sys.memoryInfo.formattedTotalRam}');

  // Display & Peripherals
  print('Refresh Rates: ${sys.displayCapabilitiesInfo.supportedRefreshRates.join(", ")} Hz');
  print('Sensors Count: ${sys.sensorsInfo.totalSensorCount}');
  print('Widevine DRM: ${sys.drmInfo.widevineSecurityLevel}');
}
```

---

### Recipe 2: FinTech / Banking Fraud Shield
Protect banking, payment, and confidential applications from emulators, debuggers, rooted devices, and GPS spoofers:

```dart
void enforceDeviceSecurity() async {
  final SecurityInfo security = await AdvancedDeviceInfo.getSecurityInfo();

  // 1. Check for compromised environment
  if (security.isCompromised) {
    throw SecurityException('Device is Rooted, Jailbroken, Debugged, or Mocking GPS');
  }

  // 2. Anti-Debugging & Anti-Tampering checks
  if (security.isDeveloperMode) {
    print('Alert: Developer Mode is toggled ON');
  }
  if (security.isAdbEnabled || security.isWirelessDebuggingEnabled) {
    print('Alert: ADB Debugging is active');
  }
  if (security.isUsbConnected) {
    print('Alert: Device connected to USB cable / PC');
  }

  // 3. Ensure user has a device lock screen set
  if (!security.isDeviceSecure) {
    print('Alert: No PIN, Pattern, or Password configured on device');
  }
}
```

---

### Recipe 3: OTT Streaming & DRM Validation
Check whether the device supports hardware-secure Widevine L1 for 1080p Full HD and 4K UHD video playback:

```dart
void verifyStreamingCapability() async {
  final DrmInfo drm = await AdvancedDeviceInfo.getDrmInfo();

  if (drm.isHdCapable) {
    print('Widevine L1 verified: Enabling 1080p / 4K UHD playback');
  } else {
    print('Widevine ${drm.widevineSecurityLevel}: Restricted to SD 480p streaming');
  }
}
```

---

### Recipe 4: Adaptive 120Hz Gaming & Thermal Throttling
Dynamically adjust graphics quality and frame rate based on device thermal status:

```dart
void configureGameSettings() async {
  final ThermalInfo thermal = await AdvancedDeviceInfo.getThermalInfo();
  final DisplayCapabilitiesInfo display = await AdvancedDeviceInfo.getDisplayCapabilitiesInfo();

  if (thermal.isThrottling) {
    // Thermal throttling detected: Reduce resolution & lock to 60 FPS
    applyQualityPreset(Quality.low);
    setTargetFps(60);
  } else if (display.supportsHighRefreshRate) {
    // Device is cool and display panel supports high refresh rate
    applyQualityPreset(Quality.ultra);
    setTargetFps(120);
  }
}
```

---

### Recipe 5: Audio Volume Level Inspector
Monitor volume streams, detect microphone mute, and identify Bluetooth A2DP audio routes:

```dart
void checkAudioRoutes() async {
  final AudioVolumeInfo audio = await AdvancedDeviceInfo.getAudioVolumeInfo();

  print('Media Volume: ${audio.mediaVolume} / ${audio.maxMediaVolume} (${audio.mediaVolumePercentage.round()}%)');
  print('Mic Hardware Muted: ${audio.isMicrophoneMute}');
  print('Bluetooth A2DP Streaming: ${audio.isBluetoothA2dpOn}');
}
```

---

### Recipe 6: Accessibility & Theme Synchronization
Adapt application layouts based on system font scale multipliers and screen readers:

```dart
void adaptUserExperience() async {
  final LocaleThemeInfo locale = await AdvancedDeviceInfo.getLocaleThemeInfo();

  print('Timezone: ${locale.timezoneId} (${locale.formattedUtcOffset})');
  print('Preferred Languages: ${locale.preferredLanguages.join(", ")}');
  print('24-Hour Clock: ${locale.is24HourFormat}');
  print('System Font Scale: ${locale.fontScale}x');
  print('TalkBack / VoiceOver Active: ${locale.isScreenReaderActive}');
  print('Dark Mode: ${locale.isDarkMode}');
}
```

---

## 📚 Comprehensive API & Model Reference

### Public API Methods (`AdvancedDeviceInfo`)
| Method | Return Type | Description |
|---|---|---|
| `AdvancedDeviceInfo.getSystemInfo()` | `Future<SystemInfo>` | Full aggregated system snapshot (all metrics in 1 call) |
| `AdvancedDeviceInfo.getDeviceInfo()` | `Future<DeviceInfo>` | Brand, model, OS release, security patch, kernel, radio, bootloader, uptime |
| `AdvancedDeviceInfo.getSecurityInfo()` | `Future<SecurityInfo>` | Root, jailbreak, developer mode, ADB, wireless ADB, mock location, debugger |
| `AdvancedDeviceInfo.getThermalInfo()` | `Future<ThermalInfo>` | Thermal throttling state (`NONE` to `CRITICAL`), battery saver, doze mode |
| `AdvancedDeviceInfo.getDrmInfo()` | `Future<DrmInfo>` | Widevine security level (`L1`/`L3`), vendor, version, system ID, HD streaming capability |
| `AdvancedDeviceInfo.getBiometricInfo()` | `Future<BiometricInfo>` | Biometric hardware presence, fingerprint, face, iris, and user enrollment status |
| `AdvancedDeviceInfo.getSensorsInfo()` | `Future<SensorsInfo>` | Total sensors count, list of sensor names, accelerometer, gyroscope, barometer |
| `AdvancedDeviceInfo.getDisplayCapabilitiesInfo()` | `Future<DisplayCapabilitiesInfo>` | HDR10, Dolby Vision, HLG, DCI-P3 wide gamut, supported refresh rates, brightness |
| `AdvancedDeviceInfo.getPeripheralsInfo()` | `Future<PeripheralsInfo>` | NFC, Bluetooth, camera counts, flashlight, vibrator amplitude control |
| `AdvancedDeviceInfo.getAudioVolumeInfo()` | `Future<AudioVolumeInfo>` | Media, ring, call, alarm, notification volume levels, mic mute, Bluetooth A2DP |
| `AdvancedDeviceInfo.getLocaleThemeInfo()` | `Future<LocaleThemeInfo>` | Timezone ID, UTC offset, preferred languages, 24h clock, font scale, TalkBack, dark mode |
| `AdvancedDeviceInfo.getLiveHardwareInfo()` | `Future<LiveHardwareInfo>` | Interactive screen on/off, Wi-Fi radio adapter, in-call status, headphones, SIM slots |
| `AdvancedDeviceInfo.getBatteryInfo()` | `Future<BatteryInfo>` | Battery level, charging state, power source, health, temperature, power saver |
| `AdvancedDeviceInfo.getNetworkInfo()` | `Future<NetworkInfo>` | Online status, connection type (wifi/cellular/vpn), active VPN tunnel detection |
| `AdvancedDeviceInfo.getStorageInfo()` | `Future<StorageInfo>` | Total, free, and used storage bytes with `.formattedUsedStorage` getters |
| `AdvancedDeviceInfo.getMemoryInfo()` | `Future<MemoryInfo>` | Total, available, and used RAM bytes with `.formattedAvailableRam` getters |
| `AdvancedDeviceInfo.getCpuInfo()` | `Future<CpuInfo>` | CPU architecture and core count |
| `AdvancedDeviceInfo.getScreenInfo()` | `Future<ScreenInfo>` | Physical screen width, height, scale density, and refresh rate in Hz |

---

### Model Classes & Property Catalog

#### 🛡️ `SecurityInfo`
| Property | Type | Description |
|---|---|---|
| `isRooted` | `bool` | True if Android root binaries or Magisk detected |
| `isJailbroken` | `bool` | True if iOS jailbreak files/sandbox compromised |
| `isDeveloperMode` | `bool` | True if Developer Options are enabled |
| `isAdbEnabled` | `bool` | True if USB debugging (ADB) is enabled |
| `isWirelessDebuggingEnabled` | `bool` | True if Wireless ADB (Android 11+) is active |
| `isUsbConnected` | `bool` | True if phone is plugged into a USB cable/PC |
| `isMockLocation` | `bool` | True if mock location provider is active |
| `isStayAwake` | `bool` | True if stay awake on charge developer setting is ON |
| `isVerificationOfAppsOverUsb` | `bool` | True if app verification over USB is enforced |
| `isDeviceSecure` | `bool` | True if PIN, Pattern, Password, or Biometric lock is set |
| `isDebuggerAttached` | `bool` | True if a native or Java debugger is actively attached |
| `isCompromised` | `bool` | True if root, jailbreak, debugger, or mock GPS is detected |

#### 🌡️ `ThermalInfo`
| Property | Type | Description |
|---|---|---|
| `thermalStatus` | `String` | `NONE`, `LIGHT`, `MODERATE`, `SEVERE`, `CRITICAL`, `EMERGENCY`, `SHUTDOWN` |
| `isPowerSaveMode` | `bool` | True if system Battery Saver / Low Power Mode is active |
| `isDeviceIdleMode` | `bool` | True if device is in Doze / deep sleep mode |
| `isThrottling` | `bool` | True if thermalStatus is MODERATE or higher |

#### 🎬 `DrmInfo`
| Property | Type | Description |
|---|---|---|
| `widevineSecurityLevel` | `String` | Widevine security level: `L1`, `L2`, `L3`, or `N/A` |
| `widevineVendor` | `String` | DRM vendor identifier (e.g. `Google`, `Apple Inc.`) |
| `widevineVersion` | `String` | DRM library release version string |
| `systemId` | `int` | Hardware cryptographic system identifier |
| `isHdCapable` | `bool` | True if widevineSecurityLevel is L1 (1080p/4K certified) |
| `isWidevineSupported` | `bool` | True if Widevine DRM is present |

#### 🔐 `BiometricInfo`
| Property | Type | Description |
|---|---|---|
| `hasBiometrics` | `bool` | True if biometric authentication hardware is present |
| `isEnrolled` | `bool` | True if user has registered biometric credentials |
| `supportedTypes` | `List<String>` | Modalities list (`fingerprint`, `face`, `iris`, `optic`) |
| `hasFingerprint` | `bool` | True if fingerprint hardware exists |
| `hasFaceId` | `bool` | True if face recognition hardware exists |
| `hasIris` | `bool` | True if iris recognition hardware exists |

#### 🧭 `SensorsInfo`
| Property | Type | Description |
|---|---|---|
| `hasAccelerometer` | `bool` | True if 3-axis accelerometer sensor is present |
| `hasGyroscope` | `bool` | True if gyroscope sensor is present |
| `hasBarometer` | `bool` | True if pressure sensor / altimeter is present |
| `hasMagnetometer` | `bool` | True if magnetic field sensor / digital compass is present |
| `hasProximity` | `bool` | True if proximity sensor is present |
| `hasStepCounter` | `bool` | True if hardware pedometer is present |
| `hasLight` | `bool` | True if ambient light sensor is present |
| `totalSensorCount` | `int` | Total count of all hardware sensors registered on device |
| `sensorNames` | `List<String>` | List of physical sensor hardware names |

#### 🖥️ `DisplayCapabilitiesInfo`
| Property | Type | Description |
|---|---|---|
| `isHdrSupported` | `bool` | True if display panel supports HDR playback |
| `supportedHdrTypes` | `List<String>` | Formats: `HDR10`, `HDR10_PLUS`, `DOLBY_VISION`, `HLG` |
| `isWideColorGamut` | `bool` | True if panel supports DCI-P3 wide color gamut |
| `supportedRefreshRates` | `List<double>` | All supported refresh frequencies (e.g. `[60.0, 120.0]`) |
| `screenBrightness` | `int` | Display brightness level index (0–255), or -1 if unknown |
| `isAutoBrightnessEnabled` | `bool` | True if adaptive / auto-brightness mode is enabled |
| `supportsHighRefreshRate` | `bool` | True if display panel supports refresh rates > 60Hz |

#### 🧰 `PeripheralsInfo`
| Property | Type | Description |
|---|---|---|
| `isNfcAvailable` | `bool` | True if NFC hardware chip is present on device |
| `isNfcEnabled` | `bool` | True if NFC adapter is currently toggled ON |
| `isBluetoothAvailable` | `bool` | True if Bluetooth radio hardware is present |
| `isBluetoothEnabled` | `bool` | True if Bluetooth adapter is currently toggled ON |
| `hasFlashlight` | `bool` | True if LED camera flash / torch is available |
| `cameraCount` | `int` | Total physical camera lenses detected |
| `frontCameraCount` | `int` | Number of front-facing / selfie camera lenses |
| `backCameraCount` | `int` | Number of rear-facing camera lenses |
| `hasVibrator` | `bool` | True if vibration motor is present |
| `hasAmplitudeControl` | `bool` | True if vibration motor supports advanced amplitude haptics |

#### 🔊 `AudioVolumeInfo`
| Property | Type | Description |
|---|---|---|
| `mediaVolume` | `int` | Current media volume index |
| `maxMediaVolume` | `int` | Maximum media volume index |
| `ringVolume` | `int` | Current ringtone volume index |
| `maxRingVolume` | `int` | Maximum ringtone volume index |
| `callVolume` | `int` | Current in-call voice volume index |
| `maxCallVolume` | `int` | Maximum in-call voice volume index |
| `alarmVolume` | `int` | Current alarm volume index |
| `maxAlarmVolume` | `int` | Maximum alarm volume index |
| `notificationVolume` | `int` | Current notification sound volume index |
| `maxNotificationVolume` | `int` | Maximum notification sound volume index |
| `mediaVolumePercentage` | `double` | Normalized media volume from 0.0% to 100.0% |
| `isMicrophoneMute` | `bool` | True if microphone is muted at system level |
| `isBluetoothA2dpOn` | `bool` | True if high-definition Bluetooth A2DP audio is active |

#### 🌐 `LocaleThemeInfo`
| Property | Type | Description |
|---|---|---|
| `timezoneId` | `String` | Canonical timezone ID (e.g. `Asia/Kolkata`, `America/New_York`) |
| `timezoneDisplayName` | `String` | Localized timezone display name (e.g. `India Standard Time`) |
| `timezoneOffsetSeconds` | `int` | Timezone offset from UTC in seconds |
| `formattedUtcOffset` | `String` | Formatted UTC offset string (e.g. `+05:30`, `-04:00`) |
| `preferredLanguages` | `List<String>` | User's ordered list of preferred languages (e.g. `["en-US"]`) |
| `is24HourFormat` | `bool` | True if system clock is set to 24-hour format |
| `fontScale` | `double` | Accessibility system font scale multiplier (1.0 = normal) |
| `isScreenReaderActive` | `bool` | True if TalkBack (Android) or VoiceOver (iOS) is running |
| `isDarkMode` | `bool` | True if system is running in dark mode |

#### ⚡ `LiveHardwareInfo`
| Property | Type | Description |
|---|---|---|
| `isScreenOn` | `bool` | True if display screen is interactive and turned on |
| `isWifiEnabled` | `bool` | True if Wi-Fi radio adapter is toggled ON |
| `isCallActive` | `bool` | True if phone call or VoIP audio call is in progress |
| `isHeadphonesConnected` | `bool` | True if wired or Bluetooth headphones are connected |
| `simSlotCount` | `int` | Hardware SIM / modem slots (1 = Single SIM, 2 = Dual SIM) |
| `isDualSim` | `bool` | True if device has 2 or more physical SIM slots |

#### 🔋 `BatteryInfo`
| Property | Type | Description |
|---|---|---|
| `batteryLevel` | `int` | Current battery level (0–100%) |
| `isCharging` | `bool` | True if device is actively charging |
| `batteryStatus` | `String` | `charging`, `discharging`, `full`, `notCharging` |
| `powerSource` | `String` | `ac`, `usb`, `wireless`, `dock`, `none` |
| `batteryHealth` | `String` | `good`, `overheat`, `dead`, `over_voltage`, `cold` |
| `batteryTemperature` | `double` | Current battery temperature in °Celsius |
| `temperatureFahrenheit` | `double` | Current battery temperature in °Fahrenheit |
| `isLowPowerMode` | `bool` | True if system battery saver is active |
| `isLow` | `bool` | True if batteryLevel <= 20% |
| `isFull` | `bool` | True if batteryLevel >= 95% |

#### 📶 `NetworkInfo`
| Property | Type | Description |
|---|---|---|
| `isConnected` | `bool` | True if device has active internet access |
| `isOffline` | `bool` | True if device has no internet access |
| `connectionType` | `String` | `wifi`, `cellular`, `ethernet`, `bluetooth`, `vpn`, `none` |
| `isVpnActive` | `bool` | True if active VPN tunnel or proxy route detected |
| `isWifi` | `bool` | True if connectionType is `wifi` |
| `isCellular` | `bool` | True if connectionType is `cellular` |

#### 📱 `DeviceInfo`
| Property | Type | Description |
|---|---|---|
| `deviceName` | `String` | User-visible device name or Bluetooth device name |
| `manufacturer` | `String` | Hardware manufacturer (e.g. `Google`, `realme`, `Apple`) |
| `model` | `String` | Hardware model identifier (e.g. `Pixel 9 Pro`, `RMX3998`) |
| `brand` | `String` | Device brand name (e.g. `realme`, `google`) |
| `isEmulator` | `bool` | True if running on an emulator or simulator |
| `securityPatch` | `String` | Android security patch level date (e.g. `2024-05-01`) |
| `kernelVersion` | `String` | Operating system kernel release (e.g. `Linux 5.15.78`) |
| `radioVersion` | `String` | Cellular modem baseband firmware version |
| `bootloader` | `String` | Device bootloader version |
| `board` | `String` | Hardware motherboard / chipset board name |
| `supportedAbis` | `String` | Supported CPU ABIs (e.g. `arm64-v8a, armeabi-v7a`) |
| `osVersion` | `String` | Operating system version release string |
| `formattedUptime` | `String` | Formatted uptime string (e.g. `"2d 4h 15m"`) |

#### 💾 `StorageInfo` & 🧠 `MemoryInfo`
| Property | Type | Description |
|---|---|---|
| `totalStorage` / `totalRam` | `int` | Total storage or RAM in bytes |
| `freeStorage` / `availableRam` | `int` | Available free storage or RAM in bytes |
| `usedStorage` / `usedRam` | `int` | Used storage or RAM in bytes |
| `usagePercentage` | `double` | Usage percentage (0.0 to 100.0%) |
| `totalStorageGB` / `totalRamGB` | `double` | Total capacity in Gigabytes |
| `usedStorageGB` / `usedRamGB` | `double` | Used capacity in Gigabytes |
| `freeStorageGB` / `availableRamGB` | `double` | Free capacity in Gigabytes |
| `formattedUsedStorage` | `String` | Human-readable used storage (e.g. `"54.2 GB"`) |
| `formattedTotalStorage` | `String` | Human-readable total storage (e.g. `"128.0 GB"`) |
| `formattedUsedRam` | `String` | Human-readable used RAM (e.g. `"4.5 GB"`) |
| `formattedTotalRam` | `String` | Human-readable total RAM (e.g. `"8.0 GB"`) |
| `isLowStorage(threshold: 90)` | `bool` | True if storage usage exceeds threshold |
| `isLowMemory(threshold: 85)` | `bool` | True if RAM usage exceeds threshold |

---

## 🔒 Zero-Permission Architecture

Over **95%** of features provided by `advanced_device_info` require **no dangerous runtime permissions**:
- Does **NOT** require sensitive permissions like `READ_CALL_LOG`, `QUERY_ALL_PACKAGES`, or `PACKAGE_USAGE_STATS`.
- Completely compliant with Google Play Store and Apple App Store review guidelines.
- Instant, silent initialization without interrupting users with runtime permission prompts.

---

## 🤝 Contributing & Support

- Contributions, bug reports, and feature suggestions are welcome!
- GitHub Repository: [naitikharkhani7/advanced_device_info](https://github.com/naitikharkhani7/advanced_device_info)
- Issues & Bug Reports: [Submit an issue](https://github.com/naitikharkhani7/advanced_device_info/issues)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.