import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_device_info/advanced_device_info.dart';
import 'package:advanced_device_info/advanced_device_info_platform_interface.dart';
import 'package:advanced_device_info/advanced_device_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdvancedDeviceInfoPlatform
    with MockPlatformInterfaceMixin
    implements AdvancedDeviceInfoPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<DeviceInfo> getDeviceInfo() => Future.value(const DeviceInfo(
        deviceName: 'Mock Phone',
        manufacturer: 'Mock Manufacturer',
        model: 'Mock Model',
        brand: 'Mock Brand',
        buildInfo: {
          'release': '14',
          'securityPatch': '2024-05-01',
          'kernelVersion': 'Linux 5.15.78',
          'radioVersion': 'g5300g-240115',
          'bootloader': 'c10-0.6',
          'board': 'shasta',
          'supportedAbis': 'arm64-v8a',
          'uptimeMillis': 86400000,
        },
        isEmulator: true,
      ));

  @override
  Future<StorageInfo> getStorageInfo() => Future.value(const StorageInfo(
        totalStorage: 107374182400, // 100 GB
        freeStorage: 53687091200,   // 50 GB
        usedStorage: 53687091200,   // 50 GB
        usagePercentage: 50.0,
      ));

  @override
  Future<MemoryInfo> getMemoryInfo() => Future.value(const MemoryInfo(
        totalRam: 8589934592,       // 8 GB
        availableRam: 4294967296,   // 4 GB
        usedRam: 4294967296,        // 4 GB
        usagePercentage: 50.0,
      ));

  @override
  Future<CpuInfo> getCpuInfo() => Future.value(const CpuInfo(
        architecture: 'arm64',
        cores: 8,
      ));

  @override
  Future<ScreenInfo> getScreenInfo() => Future.value(const ScreenInfo(
        width: 1080,
        height: 1920,
        scale: 3.0,
        refreshRate: 60.0,
      ));

  @override
  Future<BatteryInfo> getBatteryInfo() => Future.value(const BatteryInfo(
        batteryLevel: 85,
        isCharging: true,
        batteryStatus: 'charging',
        powerSource: 'usb',
        batteryHealth: 'good',
        batteryTemperature: 31.5,
        isLowPowerMode: false,
      ));

  @override
  Future<SecurityInfo> getSecurityInfo() => Future.value(const SecurityInfo(
        isRooted: false,
        isJailbroken: false,
        isDeveloperMode: true,
        isAdbEnabled: true,
        isUsbConnected: true,
        isDeviceSecure: true,
        isDebuggerAttached: false,
      ));

  @override
  Future<NetworkInfo> getNetworkInfo() => Future.value(const NetworkInfo(
        isConnected: true,
        connectionType: 'wifi',
        isVpnActive: false,
      ));

  @override
  Future<DrmInfo> getDrmInfo() => Future.value(const DrmInfo(
        widevineSecurityLevel: 'L1',
        widevineVendor: 'Google',
        widevineVersion: '16.0.0',
        systemId: 4242,
      ));

  @override
  Future<BiometricInfo> getBiometricInfo() => Future.value(const BiometricInfo(
        hasBiometrics: true,
        isEnrolled: true,
        supportedTypes: ['fingerprint', 'face'],
      ));

  @override
  Future<SensorsInfo> getSensorsInfo() => Future.value(const SensorsInfo(
        hasAccelerometer: true,
        hasGyroscope: true,
        hasBarometer: false,
        hasMagnetometer: true,
        hasProximity: true,
        hasStepCounter: true,
        hasLight: true,
        totalSensorCount: 15,
        sensorNames: ['Accelerometer', 'Gyroscope', 'Magnetometer'],
      ));

  @override
  Future<LiveHardwareInfo> getLiveHardwareInfo() => Future.value(const LiveHardwareInfo(
        isScreenOn: true,
        isWifiEnabled: true,
        isCallActive: false,
        isHeadphonesConnected: true,
        simSlotCount: 2,
      ));

  @override
  Future<ThermalInfo> getThermalInfo() => Future.value(const ThermalInfo(
        thermalStatus: 'NONE',
        isPowerSaveMode: false,
        isDeviceIdleMode: false,
      ));

  @override
  Future<DisplayCapabilitiesInfo> getDisplayCapabilitiesInfo() =>
      Future.value(const DisplayCapabilitiesInfo(
        isHdrSupported: true,
        supportedHdrTypes: ['HDR10', 'DOLBY_VISION'],
        isWideColorGamut: true,
        supportedRefreshRates: [60.0, 120.0],
        screenBrightness: 180,
        isAutoBrightnessEnabled: true,
      ));

  @override
  Future<PeripheralsInfo> getPeripheralsInfo() => Future.value(const PeripheralsInfo(
        isNfcAvailable: true,
        isNfcEnabled: true,
        isBluetoothAvailable: true,
        isBluetoothEnabled: true,
        hasFlashlight: true,
        cameraCount: 3,
        frontCameraCount: 1,
        backCameraCount: 2,
        hasVibrator: true,
        hasAmplitudeControl: true,
      ));

  @override
  Future<AudioVolumeInfo> getAudioVolumeInfo() => Future.value(const AudioVolumeInfo(
        mediaVolume: 10,
        maxMediaVolume: 15,
        ringVolume: 5,
        maxRingVolume: 7,
        callVolume: 4,
        maxCallVolume: 6,
        alarmVolume: 6,
        maxAlarmVolume: 7,
        notificationVolume: 5,
        maxNotificationVolume: 7,
        isMicrophoneMute: false,
        isBluetoothA2dpOn: false,
      ));

  @override
  Future<LocaleThemeInfo> getLocaleThemeInfo() => Future.value(const LocaleThemeInfo(
        timezoneId: 'Asia/Kolkata',
        timezoneDisplayName: 'IST',
        timezoneOffsetSeconds: 19800,
        preferredLanguages: ['en-US', 'hi-IN'],
        is24HourFormat: true,
        fontScale: 1.0,
        isScreenReaderActive: false,
        isDarkMode: true,
      ));

  @override
  Future<SystemInfo> getSystemInfo() => Future.value(const SystemInfo(
        deviceInfo: DeviceInfo(
          deviceName: 'Mock Phone',
          manufacturer: 'Mock Manufacturer',
          model: 'Mock Model',
          brand: 'Mock Brand',
          buildInfo: {},
          isEmulator: true,
        ),
        storageInfo: StorageInfo(
          totalStorage: 107374182400,
          freeStorage: 53687091200,
          usedStorage: 53687091200,
          usagePercentage: 50.0,
        ),
        memoryInfo: MemoryInfo(
          totalRam: 8589934592,
          availableRam: 4294967296,
          usedRam: 4294967296,
          usagePercentage: 50.0,
        ),
        cpuInfo: CpuInfo(
          architecture: 'arm64',
          cores: 8,
        ),
        screenInfo: ScreenInfo(
          width: 1080,
          height: 1920,
          scale: 3.0,
          refreshRate: 60.0,
        ),
        batteryInfo: BatteryInfo(
          batteryLevel: 85,
          isCharging: true,
          batteryStatus: 'charging',
          powerSource: 'usb',
          batteryHealth: 'good',
          batteryTemperature: 31.5,
          isLowPowerMode: false,
        ),
        securityInfo: SecurityInfo(
          isRooted: false,
          isJailbroken: false,
          isDeveloperMode: true,
          isAdbEnabled: true,
          isUsbConnected: true,
          isDeviceSecure: true,
          isDebuggerAttached: false,
        ),
        networkInfo: NetworkInfo(
          isConnected: true,
          connectionType: 'wifi',
          isVpnActive: false,
        ),
      ));
}

void main() {
  final AdvancedDeviceInfoPlatform initialPlatform = AdvancedDeviceInfoPlatform.instance;

  test('$MethodChannelAdvancedDeviceInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdvancedDeviceInfo>());
  });

  group('AdvancedDeviceInfo Platform Mock Tests', () {
    late AdvancedDeviceInfo advancedDeviceInfo;
    late MockAdvancedDeviceInfoPlatform fakePlatform;

    setUp(() {
      advancedDeviceInfo = AdvancedDeviceInfo();
      fakePlatform = MockAdvancedDeviceInfoPlatform();
      AdvancedDeviceInfoPlatform.instance = fakePlatform;
    });

    test('getPlatformVersion', () async {
      expect(await advancedDeviceInfo.getPlatformVersion(), '42');
    });

    test('getDeviceInfo', () async {
      final info = await AdvancedDeviceInfo.getDeviceInfo();
      expect(info.deviceName, 'Mock Phone');
      expect(info.manufacturer, 'Mock Manufacturer');
      expect(info.model, 'Mock Model');
      expect(info.brand, 'Mock Brand');
      expect(info.isEmulator, true);
      expect(info.osVersion, '14');
      expect(info.securityPatch, '2024-05-01');
      expect(info.kernelVersion, 'Linux 5.15.78');
      expect(info.radioVersion, 'g5300g-240115');
      expect(info.bootloader, 'c10-0.6');
      expect(info.board, 'shasta');
      expect(info.supportedAbis, 'arm64-v8a');
      expect(info.formattedUptime, '1d 0h 0m');
    });

    test('getStorageInfo and convenience getters', () async {
      final info = await AdvancedDeviceInfo.getStorageInfo();
      expect(info.totalStorage, 107374182400);
      expect(info.freeStorage, 53687091200);
      expect(info.usedStorage, 53687091200);
      expect(info.usagePercentage, 50.0);
      expect(info.totalStorageGB, 100.0);
      expect(info.usedStorageGB, 50.0);
      expect(info.freeStorageGB, 50.0);
      expect(info.formattedTotalStorage, '100.0 GB');
      expect(info.isLowStorage(), false);
    });

    test('getMemoryInfo and convenience getters', () async {
      final info = await AdvancedDeviceInfo.getMemoryInfo();
      expect(info.totalRam, 8589934592);
      expect(info.availableRam, 4294967296);
      expect(info.usedRam, 4294967296);
      expect(info.usagePercentage, 50.0);
      expect(info.totalRamGB, 8.0);
      expect(info.formattedTotalRam, '8.0 GB');
      expect(info.isLowMemory(), false);
    });

    test('getCpuInfo', () async {
      final info = await AdvancedDeviceInfo.getCpuInfo();
      expect(info.architecture, 'arm64');
      expect(info.cores, 8);
    });

    test('getScreenInfo', () async {
      final info = await AdvancedDeviceInfo.getScreenInfo();
      expect(info.width, 1080);
      expect(info.height, 1920);
      expect(info.scale, 3.0);
      expect(info.refreshRate, 60.0);
    });

    test('getBatteryInfo', () async {
      final info = await AdvancedDeviceInfo.getBatteryInfo();
      expect(info.batteryLevel, 85);
      expect(info.isCharging, true);
      expect(info.batteryStatus, 'charging');
      expect(info.powerSource, 'usb');
      expect(info.batteryHealth, 'good');
      expect(info.batteryTemperature, 31.5);
      expect(info.isLowPowerMode, false);
    });

    test('getSecurityInfo', () async {
      final info = await AdvancedDeviceInfo.getSecurityInfo();
      expect(info.isRooted, false);
      expect(info.isJailbroken, false);
      expect(info.isDeveloperMode, true);
      expect(info.isAdbEnabled, true);
      expect(info.isWirelessDebuggingEnabled, false);
      expect(info.isStayAwake, false);
      expect(info.isMockLocation, false);
      expect(info.isVerificationOfAppsOverUsb, false);
      expect(info.isUsbConnected, true);
      expect(info.isDeviceSecure, true);
      expect(info.isDebuggerAttached, false);
      expect(info.isCompromised, false);
    });

    test('getNetworkInfo', () async {
      final info = await AdvancedDeviceInfo.getNetworkInfo();
      expect(info.isConnected, true);
      expect(info.connectionType, 'wifi');
      expect(info.isVpnActive, false);
    });

    test('getDrmInfo', () async {
      final info = await AdvancedDeviceInfo.getDrmInfo();
      expect(info.widevineSecurityLevel, 'L1');
      expect(info.isHdCapable, true);
      expect(info.widevineVendor, 'Google');
    });

    test('getBiometricInfo', () async {
      final info = await AdvancedDeviceInfo.getBiometricInfo();
      expect(info.hasBiometrics, true);
      expect(info.hasFingerprint, true);
      expect(info.hasFaceId, true);
    });

    test('getSensorsInfo', () async {
      final info = await AdvancedDeviceInfo.getSensorsInfo();
      expect(info.hasAccelerometer, true);
      expect(info.hasGyroscope, true);
      expect(info.hasBarometer, false);
      expect(info.totalSensorCount, 15);
    });

    test('getLiveHardwareInfo', () async {
      final info = await AdvancedDeviceInfo.getLiveHardwareInfo();
      expect(info.isScreenOn, true);
      expect(info.isWifiEnabled, true);
      expect(info.isCallActive, false);
      expect(info.isHeadphonesConnected, true);
      expect(info.simSlotCount, 2);
    });

    test('getThermalInfo', () async {
      final info = await AdvancedDeviceInfo.getThermalInfo();
      expect(info.thermalStatus, 'NONE');
      expect(info.isPowerSaveMode, false);
      expect(info.isThrottling, false);
    });

    test('getDisplayCapabilitiesInfo', () async {
      final info = await AdvancedDeviceInfo.getDisplayCapabilitiesInfo();
      expect(info.isHdrSupported, true);
      expect(info.supportedHdrTypes, contains('HDR10'));
      expect(info.supportedRefreshRates, contains(120.0));
      expect(info.isWideColorGamut, true);
    });

    test('getPeripheralsInfo', () async {
      final info = await AdvancedDeviceInfo.getPeripheralsInfo();
      expect(info.isNfcAvailable, true);
      expect(info.hasFlashlight, true);
      expect(info.cameraCount, 3);
      expect(info.hasVibrator, true);
    });

    test('getAudioVolumeInfo', () async {
      final info = await AdvancedDeviceInfo.getAudioVolumeInfo();
      expect(info.mediaVolume, 10);
      expect(info.maxMediaVolume, 15);
      expect(info.isMicrophoneMute, false);
    });

    test('getLocaleThemeInfo', () async {
      final info = await AdvancedDeviceInfo.getLocaleThemeInfo();
      expect(info.timezoneId, 'Asia/Kolkata');
      expect(info.is24HourFormat, true);
      expect(info.formattedUtcOffset, '+05:30');
      expect(info.isDarkMode, true);
    });

    test('getSystemInfo', () async {
      final info = await AdvancedDeviceInfo.getSystemInfo();
      expect(info.deviceInfo.deviceName, 'Mock Phone');
      expect(info.batteryInfo.batteryLevel, 85);
      expect(info.securityInfo.isDeveloperMode, true);
      expect(info.networkInfo.connectionType, 'wifi');
    });
  });
}

