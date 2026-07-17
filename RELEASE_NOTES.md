# Release Notes - v0.0.1

We are excited to announce the initial release of `advanced_device_info` (v0.0.1)! This package is designed to provide comprehensive, low-overhead, and high-reliability access to Android and iOS device information, hardware specs, memory/storage usage, and display metrics.

## What's New in v0.0.1

This initial release introduces the core APIs and native bindings for both Android (Kotlin) and iOS (Swift) platforms.

### Key Features

*   **📱 Device Info:** Retrieve general brand, manufacturer, model, OS version, emulator status, and raw hardware build details.
*   **💾 Storage Info:** Query total, free, and used disk storage space in bytes, with real-time usage percentages.
*   **🧠 RAM Memory Info:** Query total system RAM, available/free RAM, and used RAM.
*   **⚡ CPU Info:** Retrieve CPU architecture (e.g., `arm64`, `x86_64`) and active core counts.
*   **🖥️ Screen & Display Info:** Fetch device screen dimensions, refresh rate, and pixel density scale.
*   **🔄 Unified System Info:** Request all categories of information in a single, efficient native call to minimize bridge communication overhead.

## API Usage Example

```dart
import 'package:advanced_device_info/advanced_device_info.dart';

void fetchInfo() async {
  try {
    // Get all system info in one call
    final systemInfo = await AdvancedDeviceInfo.getSystemInfo();
    print("Device Name: ${systemInfo.deviceInfo.deviceName}");
    print("RAM Free: ${systemInfo.memoryInfo.freeBytes}");
    print("Refresh Rate: ${systemInfo.screenInfo.refreshRate} Hz");
  } catch (e) {
    print("Failed to fetch device info: $e");
  }
}
```

## Platform Support

*   **Android:** API level 21 (Lollipop) and above.
*   **iOS:** iOS 12.0 and above.
