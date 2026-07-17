import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'advanced_device_info_platform_interface.dart';
import 'src/device_info_models.dart';

/// An implementation of [AdvancedDeviceInfoPlatform] that uses method channels.
class MethodChannelAdvancedDeviceInfo extends AdvancedDeviceInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('advanced_device_info');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getDeviceInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getDeviceInfo returned null',
      );
    }
    return DeviceInfo.fromMap(map);
  }

  @override
  Future<StorageInfo> getStorageInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getStorageInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getStorageInfo returned null',
      );
    }
    return StorageInfo.fromMap(map);
  }

  @override
  Future<MemoryInfo> getMemoryInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getMemoryInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getMemoryInfo returned null',
      );
    }
    return MemoryInfo.fromMap(map);
  }

  @override
  Future<CpuInfo> getCpuInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getCpuInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getCpuInfo returned null',
      );
    }
    return CpuInfo.fromMap(map);
  }

  @override
  Future<ScreenInfo> getScreenInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getScreenInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getScreenInfo returned null',
      );
    }
    return ScreenInfo.fromMap(map);
  }

  @override
  Future<SystemInfo> getSystemInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getSystemInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getSystemInfo returned null',
      );
    }
    return SystemInfo.fromMap(map);
  }
}
