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
  Future<BatteryInfo> getBatteryInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getBatteryInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getBatteryInfo returned null',
      );
    }
    return BatteryInfo.fromMap(map);
  }

  @override
  Future<SecurityInfo> getSecurityInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getSecurityInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getSecurityInfo returned null',
      );
    }
    return SecurityInfo.fromMap(map);
  }

  @override
  Future<NetworkInfo> getNetworkInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getNetworkInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getNetworkInfo returned null',
      );
    }
    return NetworkInfo.fromMap(map);
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

  @override
  Future<DrmInfo> getDrmInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getDrmInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getDrmInfo returned null',
      );
    }
    return DrmInfo.fromMap(map);
  }

  @override
  Future<BiometricInfo> getBiometricInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getBiometricInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getBiometricInfo returned null',
      );
    }
    return BiometricInfo.fromMap(map);
  }

  @override
  Future<SensorsInfo> getSensorsInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getSensorsInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getSensorsInfo returned null',
      );
    }
    return SensorsInfo.fromMap(map);
  }

  @override
  Future<LiveHardwareInfo> getLiveHardwareInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getLiveHardwareInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getLiveHardwareInfo returned null',
      );
    }
    return LiveHardwareInfo.fromMap(map);
  }

  @override
  Future<ThermalInfo> getThermalInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getThermalInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getThermalInfo returned null',
      );
    }
    return ThermalInfo.fromMap(map);
  }

  @override
  Future<DisplayCapabilitiesInfo> getDisplayCapabilitiesInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getDisplayCapabilitiesInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getDisplayCapabilitiesInfo returned null',
      );
    }
    return DisplayCapabilitiesInfo.fromMap(map);
  }

  @override
  Future<PeripheralsInfo> getPeripheralsInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getPeripheralsInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getPeripheralsInfo returned null',
      );
    }
    return PeripheralsInfo.fromMap(map);
  }

  @override
  Future<AudioVolumeInfo> getAudioVolumeInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getAudioVolumeInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getAudioVolumeInfo returned null',
      );
    }
    return AudioVolumeInfo.fromMap(map);
  }

  @override
  Future<LocaleThemeInfo> getLocaleThemeInfo() async {
    final map = await methodChannel.invokeMapMethod<dynamic, dynamic>('getLocaleThemeInfo');
    if (map == null) {
      throw PlatformException(
        code: 'NULL_RESPONSE',
        message: 'getLocaleThemeInfo returned null',
      );
    }
    return LocaleThemeInfo.fromMap(map);
  }
}

