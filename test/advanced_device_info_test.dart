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
        buildInfo: {},
        isEmulator: true,
      ));

  @override
  Future<StorageInfo> getStorageInfo() => Future.value(const StorageInfo(
        totalStorage: 1000,
        freeStorage: 500,
        usedStorage: 500,
        usagePercentage: 50.0,
      ));

  @override
  Future<MemoryInfo> getMemoryInfo() => Future.value(const MemoryInfo(
        totalRam: 1000,
        availableRam: 500,
        usedRam: 500,
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
  Future<SystemInfo> getSystemInfo() => Future.value(SystemInfo(
        deviceInfo: const DeviceInfo(
          deviceName: 'Mock Phone',
          manufacturer: 'Mock Manufacturer',
          model: 'Mock Model',
          brand: 'Mock Brand',
          buildInfo: {},
          isEmulator: true,
        ),
        storageInfo: const StorageInfo(
          totalStorage: 1000,
          freeStorage: 500,
          usedStorage: 500,
          usagePercentage: 50.0,
        ),
        memoryInfo: const MemoryInfo(
          totalRam: 1000,
          availableRam: 500,
          usedRam: 500,
          usagePercentage: 50.0,
        ),
        cpuInfo: const CpuInfo(
          architecture: 'arm64',
          cores: 8,
        ),
        screenInfo: const ScreenInfo(
          width: 1080,
          height: 1920,
          scale: 3.0,
          refreshRate: 60.0,
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
    });

    test('getStorageInfo', () async {
      final info = await AdvancedDeviceInfo.getStorageInfo();
      expect(info.totalStorage, 1000);
      expect(info.freeStorage, 500);
      expect(info.usedStorage, 500);
      expect(info.usagePercentage, 50.0);
    });

    test('getMemoryInfo', () async {
      final info = await AdvancedDeviceInfo.getMemoryInfo();
      expect(info.totalRam, 1000);
      expect(info.availableRam, 500);
      expect(info.usedRam, 500);
      expect(info.usagePercentage, 50.0);
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

    test('getSystemInfo', () async {
      final info = await AdvancedDeviceInfo.getSystemInfo();
      expect(info.deviceInfo.deviceName, 'Mock Phone');
      expect(info.storageInfo.totalStorage, 1000);
      expect(info.memoryInfo.totalRam, 1000);
      expect(info.cpuInfo.architecture, 'arm64');
      expect(info.screenInfo.width, 1080);
    });
  });
}
