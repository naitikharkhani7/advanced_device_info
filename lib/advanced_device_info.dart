import 'advanced_device_info_platform_interface.dart';
import 'src/device_info_models.dart';

export 'src/device_info_models.dart';

class AdvancedDeviceInfo {
  /// Retrieves the platform version string.
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

  /// Retrieves battery charge level, health, temperature, and charging status.
  static Future<BatteryInfo> getBatteryInfo() {
    return AdvancedDeviceInfoPlatform.instance.getBatteryInfo();
  }

  /// Retrieves device security posture, root/jailbreak detection, developer mode, and USB cable status.
  static Future<SecurityInfo> getSecurityInfo() {
    return AdvancedDeviceInfoPlatform.instance.getSecurityInfo();
  }

  /// Retrieves internet connectivity status and active VPN tunnel detection.
  static Future<NetworkInfo> getNetworkInfo() {
    return AdvancedDeviceInfoPlatform.instance.getNetworkInfo();
  }

  /// Retrieves aggregated system-wide information across all hardware, security, and network metrics.
  static Future<SystemInfo> getSystemInfo() {
    return AdvancedDeviceInfoPlatform.instance.getSystemInfo();
  }

  /// Retrieves Digital Rights Management (DRM) and Widevine security levels.
  static Future<DrmInfo> getDrmInfo() {
    return AdvancedDeviceInfoPlatform.instance.getDrmInfo();
  }

  /// Retrieves biometric hardware capabilities and enrollment state.
  static Future<BiometricInfo> getBiometricInfo() {
    return AdvancedDeviceInfoPlatform.instance.getBiometricInfo();
  }

  /// Retrieves list and presence of onboard hardware sensors.
  static Future<SensorsInfo> getSensorsInfo() {
    return AdvancedDeviceInfoPlatform.instance.getSensorsInfo();
  }

  /// Retrieves live peripheral states (screen interactive, wifi, in-call, headphones, SIM slots).
  static Future<LiveHardwareInfo> getLiveHardwareInfo() {
    return AdvancedDeviceInfoPlatform.instance.getLiveHardwareInfo();
  }
}
