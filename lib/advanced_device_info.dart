
import 'advanced_device_info_platform_interface.dart';
import 'src/device_info_models.dart';

export 'src/device_info_models.dart';

class AdvancedDeviceInfo {
  /// Keep the original instance method from the plugin template.
  Future<String?> getPlatformVersion() {
    return AdvancedDeviceInfoPlatform.instance.getPlatformVersion();
  }

  /// Retrieves general device metadata.
  static Future<DeviceInfo> getDeviceInfo() {
    return AdvancedDeviceInfoPlatform.instance.getDeviceInfo();
  }

  /// Retrieves storage capacity and usage details.
  static Future<StorageInfo> getStorageInfo() {
    return AdvancedDeviceInfoPlatform.instance.getStorageInfo();
  }

  /// Retrieves physical memory (RAM) capacity and usage details.
  static Future<MemoryInfo> getMemoryInfo() {
    return AdvancedDeviceInfoPlatform.instance.getMemoryInfo();
  }

  /// Retrieves processor capabilities.
  static Future<CpuInfo> getCpuInfo() {
    return AdvancedDeviceInfoPlatform.instance.getCpuInfo();
  }

  /// Retrieves display characteristics.
  static Future<ScreenInfo> getScreenInfo() {
    return AdvancedDeviceInfoPlatform.instance.getScreenInfo();
  }

  /// Retrieves aggregated system-wide information (all Phase 1 metrics).
  static Future<SystemInfo> getSystemInfo() {
    return AdvancedDeviceInfoPlatform.instance.getSystemInfo();
  }
}
