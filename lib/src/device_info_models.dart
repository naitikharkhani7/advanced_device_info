import 'dart:core';

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

/// Aggregated system-wide information.
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

  const SystemInfo({
    required this.deviceInfo,
    required this.storageInfo,
    required this.memoryInfo,
    required this.cpuInfo,
    required this.screenInfo,
  });

  /// Creates a [SystemInfo] from a nested map.
  factory SystemInfo.fromMap(Map<dynamic, dynamic> map) {
    return SystemInfo(
      deviceInfo: DeviceInfo.fromMap(map['deviceInfo'] as Map? ?? const {}),
      storageInfo: StorageInfo.fromMap(map['storageInfo'] as Map? ?? const {}),
      memoryInfo: MemoryInfo.fromMap(map['memoryInfo'] as Map? ?? const {}),
      cpuInfo: CpuInfo.fromMap(map['cpuInfo'] as Map? ?? const {}),
      screenInfo: ScreenInfo.fromMap(map['screenInfo'] as Map? ?? const {}),
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
    };
  }

  @override
  String toString() => 'SystemInfo(${toMap()})';
}
