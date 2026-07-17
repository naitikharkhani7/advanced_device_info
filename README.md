# advanced_device_info

A production-ready Flutter plugin for retrieving comprehensive, system-level device and hardware information on Android and iOS. Built with clean architecture, strict error safety, and high-performance native APIs.

## Features

### 📱 Device Information
* Retrieve device manufacturer, brand, model name, and user-facing device name.
* Fetch raw build metadata (SDK level, display ID, hardware, fingerprint, etc.).
* Built-in robust simulator/emulator detection.

### 💾 Storage Info
* Total disk capacity, available/free space, and used space in bytes.
* Current storage usage percentage.

### 🧠 RAM Memory Info
* Total system memory (RAM), available RAM, and used RAM in bytes.
* Real-time RAM memory usage percentage.

### ⚡ CPU Info
* Host CPU architecture (e.g. `arm64`, `x86_64`).
* Number of active processing cores.

### 🖥️ Screen/Display Info
* Screen resolution in pixels (width and height).
* Display scale / pixel density factor.
* Display refresh rate in Hz.

---

## Installation

Add `advanced_device_info` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  advanced_device_info:
    path: ../advanced_device_info # or version constraint when published
```

---

## Usage

Import the package:

```dart
import 'package:advanced_device_info/advanced_device_info.dart';
```

### Retrieve System Information

Get all hardware and system metrics in a single, highly efficient native invocation:

```dart
try {
  final SystemInfo systemInfo = await AdvancedDeviceInfo.getSystemInfo();
  
  print("Device: ${systemInfo.deviceInfo.deviceName}");
  print("RAM: ${systemInfo.memoryInfo.usagePercentage}% used");
  print("Cores: ${systemInfo.cpuInfo.cores}");
  print("Resolution: ${systemInfo.screenInfo.width}x${systemInfo.screenInfo.height}");
} catch (e) {
  print("Failed to get device info: $e");
}
```

### Retrieve Individual Metrics

You can also fetch specific categories individually:

```dart
// Device Metadata
final DeviceInfo device = await AdvancedDeviceInfo.getDeviceInfo();

// Storage Usage
final StorageInfo storage = await AdvancedDeviceInfo.getStorageInfo();

// Memory (RAM)
final MemoryInfo memory = await AdvancedDeviceInfo.getMemoryInfo();

// CPU Info
final CpuInfo cpu = await AdvancedDeviceInfo.getCpuInfo();

// Display Info
final ScreenInfo screen = await AdvancedDeviceInfo.getScreenInfo();
```


