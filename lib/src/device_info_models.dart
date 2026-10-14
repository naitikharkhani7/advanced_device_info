import 'dart:core';
import 'dart:math';

/// Formats raw bytes into human-readable strings (e.g., "64.0 GB").
String _formatBytes(int bytes, {int decimals = 1}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor().clamp(0, suffixes.length - 1);
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

/// Information about the host device.
class DeviceInfo {
  /// The user-visible name of the device.
  final String deviceName;

  /// The manufacturer of the device.
  final String manufacturer;

  /// The model of the device.
  final String model;

  /// The brand of the device.
  final String brand;

  /// Raw platform-specific build details.
  final Map<String, dynamic> buildInfo;

  /// Whether the device is an emulator or simulator.
  final bool isEmulator;

  const DeviceInfo({
    required this.deviceName,
    required this.manufacturer,
    required this.model,
    required this.brand,
    required this.buildInfo,
    required this.isEmulator,
  });

  /// Creates a [DeviceInfo] from a map.
  factory DeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return DeviceInfo(
      deviceName: map['deviceName']?.toString() ?? 'Unknown',
      manufacturer: map['manufacturer']?.toString() ?? 'Unknown',
      model: map['model']?.toString() ?? 'Unknown',
      brand: map['brand']?.toString() ?? 'Unknown',
      buildInfo: Map<String, dynamic>.from(map['buildInfo'] ?? const {}),
      isEmulator: map['isEmulator'] as bool? ?? false,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'deviceName': deviceName,
      'manufacturer': manufacturer,
      'model': model,
      'brand': brand,
      'buildInfo': buildInfo,
      'isEmulator': isEmulator,
    };
  }

  /// Android security patch level (e.g. "2024-05-01"), or "N/A" on iOS.
  String get securityPatch => buildInfo['securityPatch']?.toString() ?? 'N/A';

  /// Kernel version string (e.g. Linux 5.15 on Android, Darwin on iOS).
  String get kernelVersion => buildInfo['kernelVersion']?.toString() ?? 'Unknown';

  /// Radio / Baseband firmware version, or "N/A".
  String get radioVersion => buildInfo['radioVersion']?.toString() ?? 'N/A';

  /// Bootloader version identifier, or "N/A".
  String get bootloader => buildInfo['bootloader']?.toString() ?? 'N/A';

  /// Hardware board name, or "N/A".
  String get board => buildInfo['board']?.toString() ?? 'N/A';

  /// Supported CPU architectures / ABIs (e.g. "arm64-v8a, armeabi-v7a").
  String get supportedAbis => buildInfo['supportedAbis']?.toString() ?? 'Unknown';

  /// Operating system release or version string.
  String get osVersion =>
      buildInfo['release']?.toString() ??
      buildInfo['systemVersion']?.toString() ??
      'Unknown';

  /// System uptime formatted into human-readable string (e.g. "2d 4h 15m").
  String get formattedUptime {
    int totalSeconds = 0;
    if (buildInfo.containsKey('uptimeMillis')) {
      final millis = (buildInfo['uptimeMillis'] as num?)?.toInt() ?? 0;
      totalSeconds = (millis / 1000).round();
    } else if (buildInfo.containsKey('uptimeSeconds')) {
      totalSeconds = (buildInfo['uptimeSeconds'] as num?)?.toInt() ?? 0;
    }
    if (totalSeconds <= 0) return 'Just started';
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (days > 0) return '${days}d ${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  @override
  String toString() => 'DeviceInfo(${toMap()})';
}

/// Information about the storage capacity and usage.
class StorageInfo {
  /// Total storage space on the device in bytes.
  final int totalStorage;

  /// Available storage space on the device in bytes.
  final int freeStorage;

  /// Used storage space on the device in bytes.
  final int usedStorage;

  /// Usage percentage, between 0.0 and 100.0.
  final double usagePercentage;

  const StorageInfo({
    required this.totalStorage,
    required this.freeStorage,
    required this.usedStorage,
    required this.usagePercentage,
  });

  /// Creates a [StorageInfo] from a map.
  factory StorageInfo.fromMap(Map<dynamic, dynamic> map) {
    final total = map['totalStorage'] as int? ?? 0;
    final free = map['freeStorage'] as int? ?? 0;
    final used = map['usedStorage'] as int? ?? 0;
    final usage = (map['usagePercentage'] as num?)?.toDouble() ?? 0.0;

    return StorageInfo(
      totalStorage: total,
      freeStorage: free,
      usedStorage: used,
      usagePercentage: usage,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'totalStorage': totalStorage,
      'freeStorage': freeStorage,
      'usedStorage': usedStorage,
      'usagePercentage': usagePercentage,
    };
  }

  /// Total storage converted to Gigabytes (GB).
  double get totalStorageGB => totalStorage / (1024 * 1024 * 1024);

  /// Used storage converted to Gigabytes (GB).
  double get usedStorageGB => usedStorage / (1024 * 1024 * 1024);

  /// Free storage converted to Gigabytes (GB).
  double get freeStorageGB => freeStorage / (1024 * 1024 * 1024);

  /// Total storage converted to Megabytes (MB).
  double get totalStorageMB => totalStorage / (1024 * 1024);

  /// Used storage converted to Megabytes (MB).
  double get usedStorageMB => usedStorage / (1024 * 1024);

  /// Free storage converted to Megabytes (MB).
  double get freeStorageMB => freeStorage / (1024 * 1024);

  /// Formatted total storage (e.g. "128.0 GB").
  String get formattedTotalStorage => _formatBytes(totalStorage);

  /// Formatted used storage (e.g. "54.2 GB").
  String get formattedUsedStorage => _formatBytes(usedStorage);

  /// Formatted free storage (e.g. "73.8 GB").
  String get formattedFreeStorage => _formatBytes(freeStorage);

  /// Returns true if the storage usage percentage exceeds [thresholdPercent].
  bool isLowStorage({double thresholdPercent = 90.0}) => usagePercentage >= thresholdPercent;

  @override
  String toString() => 'StorageInfo(${toMap()})';
}

/// Information about physical memory (RAM).
class MemoryInfo {
  /// Total physical memory (RAM) in bytes.
  final int totalRam;

  /// Available physical memory (RAM) in bytes.
  final int availableRam;

  /// Used physical memory (RAM) in bytes.
  final int usedRam;

  /// Memory usage percentage, between 0.0 and 100.0.
  final double usagePercentage;

  const MemoryInfo({
    required this.totalRam,
    required this.availableRam,
    required this.usedRam,
    required this.usagePercentage,
  });

  /// Creates a [MemoryInfo] from a map.
  factory MemoryInfo.fromMap(Map<dynamic, dynamic> map) {
    final total = map['totalRam'] as int? ?? 0;
    final available = map['availableRam'] as int? ?? 0;
    final used = map['usedRam'] as int? ?? 0;
    final usage = (map['usagePercentage'] as num?)?.toDouble() ?? 0.0;

    return MemoryInfo(
      totalRam: total,
      availableRam: available,
      usedRam: used,
      usagePercentage: usage,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'totalRam': totalRam,
      'availableRam': availableRam,
      'usedRam': usedRam,
      'usagePercentage': usagePercentage,
    };
  }

  /// Total physical RAM converted to Gigabytes (GB).
  double get totalRamGB => totalRam / (1024 * 1024 * 1024);

  /// Used physical RAM converted to Gigabytes (GB).
  double get usedRamGB => usedRam / (1024 * 1024 * 1024);

  /// Available physical RAM converted to Gigabytes (GB).
  double get availableRamGB => availableRam / (1024 * 1024 * 1024);

  /// Total physical RAM converted to Megabytes (MB).
  double get totalRamMB => totalRam / (1024 * 1024);

  /// Used physical RAM converted to Megabytes (MB).
  double get usedRamMB => usedRam / (1024 * 1024);

  /// Available physical RAM converted to Megabytes (MB).
  double get availableRamMB => availableRam / (1024 * 1024);

  /// Formatted total RAM (e.g. "8.0 GB").
  String get formattedTotalRam => _formatBytes(totalRam);

  /// Formatted used RAM (e.g. "4.5 GB").
  String get formattedUsedRam => _formatBytes(usedRam);

  /// Formatted available RAM (e.g. "3.5 GB").
  String get formattedAvailableRam => _formatBytes(availableRam);

  /// Returns true if memory usage percentage exceeds [thresholdPercent].
  bool isLowMemory({double thresholdPercent = 85.0}) => usagePercentage >= thresholdPercent;

  @override
  String toString() => 'MemoryInfo(${toMap()})';
}

/// Information about the device CPU.
class CpuInfo {
  /// The CPU architecture name (e.g. arm64, x86_64).
  final String architecture;

  /// The number of CPU cores.
  final int cores;

  const CpuInfo({
    required this.architecture,
    required this.cores,
  });

  /// Creates a [CpuInfo] from a map.
  factory CpuInfo.fromMap(Map<dynamic, dynamic> map) {
    return CpuInfo(
      architecture: map['architecture']?.toString() ?? 'Unknown',
      cores: map['cores'] as int? ?? 1,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'architecture': architecture,
      'cores': cores,
    };
  }

  @override
  String toString() => 'CpuInfo(${toMap()})';
}

/// Information about the physical screen.
class ScreenInfo {
  /// Physical screen width in pixels.
  final int width;

  /// Physical screen height in pixels.
  final int height;

  /// Screen scale/density factor.
  final double scale;

  /// Refresh rate of the screen in Hz.
  final double refreshRate;

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.scale,
    required this.refreshRate,
  });

  /// Creates a [ScreenInfo] from a map.
  factory ScreenInfo.fromMap(Map<dynamic, dynamic> map) {
    return ScreenInfo(
      width: map['width'] as int? ?? 0,
      height: map['height'] as int? ?? 0,
      scale: (map['scale'] as num?)?.toDouble() ?? 1.0,
      refreshRate: (map['refreshRate'] as num?)?.toDouble() ?? 60.0,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'scale': scale,
      'refreshRate': refreshRate,
    };
  }

  @override
  String toString() => 'ScreenInfo(${toMap()})';
}

/// Information about battery health, charge level, and charging status.
class BatteryInfo {
  /// Battery percentage level, between 0 and 100 (-1 if unavailable).
  final int batteryLevel;

  /// Whether the device is currently charging or full.
  final bool isCharging;

  /// Current battery status: "charging", "discharging", "full", "notCharging", "unknown".
  final String batteryStatus;

  /// Power source: "ac", "usb", "wireless", "none", "unknown".
  final String powerSource;

  /// Battery health state (e.g. "good", "overheat", "dead", "cold").
  final String batteryHealth;

  /// Battery temperature in Celsius (e.g. 32.5°C).
  final double batteryTemperature;

  /// Whether the device is in low-power/battery-saver mode.
  final bool isLowPowerMode;

  const BatteryInfo({
    required this.batteryLevel,
    required this.isCharging,
    required this.batteryStatus,
    required this.powerSource,
    required this.batteryHealth,
    required this.batteryTemperature,
    required this.isLowPowerMode,
  });

  /// Creates a [BatteryInfo] from a map.
  factory BatteryInfo.fromMap(Map<dynamic, dynamic> map) {
    return BatteryInfo(
      batteryLevel: map['batteryLevel'] as int? ?? -1,
      isCharging: map['isCharging'] as bool? ?? false,
      batteryStatus: map['batteryStatus']?.toString() ?? 'unknown',
      powerSource: map['powerSource']?.toString() ?? 'unknown',
      batteryHealth: map['batteryHealth']?.toString() ?? 'unknown',
      batteryTemperature: (map['batteryTemperature'] as num?)?.toDouble() ?? 0.0,
      isLowPowerMode: map['isLowPowerMode'] as bool? ?? false,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'batteryLevel': batteryLevel,
      'isCharging': isCharging,
      'batteryStatus': batteryStatus,
      'powerSource': powerSource,
      'batteryHealth': batteryHealth,
      'batteryTemperature': batteryTemperature,
      'isLowPowerMode': isLowPowerMode,
    };
  }

  @override
  String toString() => 'BatteryInfo(${toMap()})';
}

/// Security, integrity, and developer/debugging inspection properties.
/// Crucial for fintech, banking, gaming, and secure enterprise apps.
class SecurityInfo {
  /// Whether the Android device is rooted (checks su binaries, test-keys, Magisk).
  final bool isRooted;

  /// Whether the iOS device is jailbroken (checks Cydia, substrate, sandbox escape).
  final bool isJailbroken;

  /// Whether Developer Options are enabled in device settings (Android).
  final bool isDeveloperMode;

  /// Whether USB Debugging (ADB) is enabled (Android).
  final bool isAdbEnabled;

  /// Whether Wireless Debugging (ADB over Wi-Fi) is enabled (Android 11+).
  final bool isWirelessDebuggingEnabled;

  /// Whether the screen is set to stay on while charging (developer setting).
  final bool isStayAwake;

  /// Whether mock location / fake GPS simulation is enabled or detected.
  final bool isMockLocation;

  /// Whether package verification of apps installed over ADB is enabled.
  final bool isVerificationOfAppsOverUsb;

  /// Whether the device is connected to a computer or charger via USB cable.
  final bool isUsbConnected;

  /// Whether the device is secured with a screen lock (PIN, pattern, password, or biometrics).
  final bool isDeviceSecure;

  /// Whether a native debugger is currently attached to the app process.
  final bool isDebuggerAttached;

  const SecurityInfo({
    required this.isRooted,
    required this.isJailbroken,
    required this.isDeveloperMode,
    required this.isAdbEnabled,
    this.isWirelessDebuggingEnabled = false,
    this.isStayAwake = false,
    this.isMockLocation = false,
    this.isVerificationOfAppsOverUsb = false,
    required this.isUsbConnected,
    required this.isDeviceSecure,
    required this.isDebuggerAttached,
  });

  /// Creates a [SecurityInfo] from a map.
  factory SecurityInfo.fromMap(Map<dynamic, dynamic> map) {
    return SecurityInfo(
      isRooted: map['isRooted'] as bool? ?? false,
      isJailbroken: map['isJailbroken'] as bool? ?? false,
      isDeveloperMode: map['isDeveloperMode'] as bool? ?? false,
      isAdbEnabled: map['isAdbEnabled'] as bool? ?? false,
      isWirelessDebuggingEnabled: map['isWirelessDebuggingEnabled'] as bool? ?? false,
      isStayAwake: map['isStayAwake'] as bool? ?? false,
      isMockLocation: map['isMockLocation'] as bool? ?? false,
      isVerificationOfAppsOverUsb: map['isVerificationOfAppsOverUsb'] as bool? ?? false,
      isUsbConnected: map['isUsbConnected'] as bool? ?? false,
      isDeviceSecure: map['isDeviceSecure'] as bool? ?? false,
      isDebuggerAttached: map['isDebuggerAttached'] as bool? ?? false,
    );
  }

  /// Returns true if the device environment is potentially untrusted
  /// (e.g. rooted, jailbroken, debugger attached, or fake mock location active).
  bool get isCompromised =>
      isRooted || isJailbroken || isDebuggerAttached || isMockLocation;

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'isRooted': isRooted,
      'isJailbroken': isJailbroken,
      'isDeveloperMode': isDeveloperMode,
      'isAdbEnabled': isAdbEnabled,
      'isWirelessDebuggingEnabled': isWirelessDebuggingEnabled,
      'isStayAwake': isStayAwake,
      'isMockLocation': isMockLocation,
      'isVerificationOfAppsOverUsb': isVerificationOfAppsOverUsb,
      'isUsbConnected': isUsbConnected,
      'isDeviceSecure': isDeviceSecure,
      'isDebuggerAttached': isDebuggerAttached,
      'isCompromised': isCompromised,
    };
  }

  @override
  String toString() => 'SecurityInfo(${toMap()})';
}

/// Network connectivity and VPN status information.
class NetworkInfo {
  /// Whether an active internet connection is available.
  final bool isConnected;

  /// Primary connection type: "wifi", "cellular", "ethernet", "vpn", "none", "unknown".
  final String connectionType;

  /// Whether an active VPN tunnel or proxy connection is detected.
  final bool isVpnActive;

  const NetworkInfo({
    required this.isConnected,
    required this.connectionType,
    required this.isVpnActive,
  });

  /// Creates a [NetworkInfo] from a map.
  factory NetworkInfo.fromMap(Map<dynamic, dynamic> map) {
    return NetworkInfo(
      isConnected: map['isConnected'] as bool? ?? false,
      connectionType: map['connectionType']?.toString() ?? 'none',
      isVpnActive: map['isVpnActive'] as bool? ?? false,
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'isConnected': isConnected,
      'connectionType': connectionType,
      'isVpnActive': isVpnActive,
    };
  }

  @override
  String toString() => 'NetworkInfo(${toMap()})';
}

/// Aggregated system-wide information containing all hardware and security metrics.
class SystemInfo {
  /// General device metadata.
  final DeviceInfo deviceInfo;

  /// Storage capacity and usage details.
  final StorageInfo storageInfo;

  /// Physical memory (RAM) capacity and usage details.
  final MemoryInfo memoryInfo;

  /// Processor capabilities.
  final CpuInfo cpuInfo;

  /// Display characteristics.
  final ScreenInfo screenInfo;

  /// Battery and charging details.
  final BatteryInfo batteryInfo;

  /// Security, root, jailbreak, and developer mode checks.
  final SecurityInfo securityInfo;

  /// Network and VPN connectivity details.
  final NetworkInfo networkInfo;

  const SystemInfo({
    required this.deviceInfo,
    required this.storageInfo,
    required this.memoryInfo,
    required this.cpuInfo,
    required this.screenInfo,
    required this.batteryInfo,
    required this.securityInfo,
    required this.networkInfo,
  });

  /// Creates a [SystemInfo] from a nested map.
  factory SystemInfo.fromMap(Map<dynamic, dynamic> map) {
    return SystemInfo(
      deviceInfo: DeviceInfo.fromMap(map['deviceInfo'] as Map? ?? const {}),
      storageInfo: StorageInfo.fromMap(map['storageInfo'] as Map? ?? const {}),
      memoryInfo: MemoryInfo.fromMap(map['memoryInfo'] as Map? ?? const {}),
      cpuInfo: CpuInfo.fromMap(map['cpuInfo'] as Map? ?? const {}),
      screenInfo: ScreenInfo.fromMap(map['screenInfo'] as Map? ?? const {}),
      batteryInfo: BatteryInfo.fromMap(map['batteryInfo'] as Map? ?? const {}),
      securityInfo: SecurityInfo.fromMap(map['securityInfo'] as Map? ?? const {}),
      networkInfo: NetworkInfo.fromMap(map['networkInfo'] as Map? ?? const {}),
    );
  }

  /// Converts this object to a map.
  Map<String, dynamic> toMap() {
    return {
      'deviceInfo': deviceInfo.toMap(),
      'storageInfo': storageInfo.toMap(),
      'memoryInfo': memoryInfo.toMap(),
      'cpuInfo': cpuInfo.toMap(),
      'screenInfo': screenInfo.toMap(),
      'batteryInfo': batteryInfo.toMap(),
      'securityInfo': securityInfo.toMap(),
      'networkInfo': networkInfo.toMap(),
    };
  }

  @override
  String toString() => 'SystemInfo(${toMap()})';
}

/// Clean extension on [int] to eliminate repeated formatBytes boilerplate.
extension ByteFormatting on int {
  /// Converts an integer representing bytes into a readable unit (e.g., "128.5 GB").
  String toReadableBytes({int decimals = 1}) {
    return _formatBytes(this, decimals: decimals);
  }
}
