import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'advanced_device_info_method_channel.dart';
import 'src/device_info_models.dart';

abstract class AdvancedDeviceInfoPlatform extends PlatformInterface {
  /// Constructs a AdvancedDeviceInfoPlatform.
  AdvancedDeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdvancedDeviceInfoPlatform _instance = MethodChannelAdvancedDeviceInfo();

  /// The default instance of [AdvancedDeviceInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdvancedDeviceInfo].
  static AdvancedDeviceInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdvancedDeviceInfoPlatform] when
  /// they register themselves.
  static set instance(AdvancedDeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<DeviceInfo> getDeviceInfo() {
    throw UnimplementedError('getDeviceInfo() has not been implemented.');
  }

  Future<StorageInfo> getStorageInfo() {
    throw UnimplementedError('getStorageInfo() has not been implemented.');
  }

  Future<MemoryInfo> getMemoryInfo() {
    throw UnimplementedError('getMemoryInfo() has not been implemented.');
  }

  Future<CpuInfo> getCpuInfo() {
    throw UnimplementedError('getCpuInfo() has not been implemented.');
  }

  Future<ScreenInfo> getScreenInfo() {
    throw UnimplementedError('getScreenInfo() has not been implemented.');
  }

  Future<BatteryInfo> getBatteryInfo() {
    throw UnimplementedError('getBatteryInfo() has not been implemented.');
  }

  Future<SecurityInfo> getSecurityInfo() {
    throw UnimplementedError('getSecurityInfo() has not been implemented.');
  }

  Future<NetworkInfo> getNetworkInfo() {
    throw UnimplementedError('getNetworkInfo() has not been implemented.');
  }

  Future<SystemInfo> getSystemInfo() {
    throw UnimplementedError('getSystemInfo() has not been implemented.');
  }

  Future<DrmInfo> getDrmInfo() {
    throw UnimplementedError('getDrmInfo() has not been implemented.');
  }

  Future<BiometricInfo> getBiometricInfo() {
    throw UnimplementedError('getBiometricInfo() has not been implemented.');
  }

  Future<SensorsInfo> getSensorsInfo() {
    throw UnimplementedError('getSensorsInfo() has not been implemented.');
  }

  Future<LiveHardwareInfo> getLiveHardwareInfo() {
    throw UnimplementedError('getLiveHardwareInfo() has not been implemented.');
  }

  Future<ThermalInfo> getThermalInfo() {
    throw UnimplementedError('getThermalInfo() has not been implemented.');
  }

  Future<DisplayCapabilitiesInfo> getDisplayCapabilitiesInfo() {
    throw UnimplementedError('getDisplayCapabilitiesInfo() has not been implemented.');
  }

  Future<PeripheralsInfo> getPeripheralsInfo() {
    throw UnimplementedError('getPeripheralsInfo() has not been implemented.');
  }

  Future<AudioVolumeInfo> getAudioVolumeInfo() {
    throw UnimplementedError('getAudioVolumeInfo() has not been implemented.');
  }

  Future<LocaleThemeInfo> getLocaleThemeInfo() {
    throw UnimplementedError('getLocaleThemeInfo() has not been implemented.');
  }
}

