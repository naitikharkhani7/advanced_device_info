import Flutter
import UIKit
import Darwin

public class AdvancedDeviceInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "advanced_device_info", binaryMessenger: registrar.messenger())
    let instance = AdvancedDeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getDeviceInfo":
      result(getDeviceInfoMap())
    case "getStorageInfo":
      result(getStorageInfoMap())
    case "getMemoryInfo":
      result(getMemoryInfoMap())
    case "getCpuInfo":
      result(getCpuInfoMap())
    case "getScreenInfo":
      result(getScreenInfoMap())
    case "getSystemInfo":
      result(getSystemInfoMap())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getDeviceInfoMap() -> [String: Any] {
    let device = UIDevice.current
    let deviceName = device.name
    let manufacturer = "Apple"
    let model = device.model
    let brand = "Apple"
    
    var modelIdentifier = "unknown"
    var size = 0
    sysctlbyname("hw.machine", nil, &size, nil, 0)
    if size > 0 {
      var machine = [CChar](repeating: 0, count: size)
      sysctlbyname("hw.machine", &machine, &size, nil, 0)
      modelIdentifier = String(cString: machine)
    }
    
    let buildInfo: [String: Any] = [
      "systemName": device.systemName,
      "systemVersion": device.systemVersion,
      "modelIdentifier": modelIdentifier,
      "localizedModel": device.localizedModel,
      "identifierForVendor": device.identifierForVendor?.uuidString ?? ""
    ]
    
    #if targetEnvironment(simulator)
    let isEmulator = true
    #else
    let isEmulator = false
    #endif
    
    return [
      "deviceName": deviceName,
      "manufacturer": manufacturer,
      "model": model,
      "brand": brand,
      "buildInfo": buildInfo,
      "isEmulator": isEmulator
    ]
  }

  private func getStorageInfoMap() -> [String: Any] {
    let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
    var totalStorage: Int64 = 0
    var freeStorage: Int64 = 0
    
    do {
      let values = try fileURL.resourceValues(forKeys: [
        .volumeTotalCapacityKey,
        .volumeAvailableCapacityForImportantUsageKey
      ])
      totalStorage = Int64(values.volumeTotalCapacity ?? 0)
      freeStorage = Int64(values.volumeAvailableCapacityForImportantUsage ?? 0)
    } catch {
      if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
        totalStorage = (attributes[.systemSize] as? NSNumber)?.int64Value ?? 0
        freeStorage = (attributes[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
      }
    }
    
    let usedStorage = max(0, totalStorage - freeStorage)
    let usagePercentage = totalStorage > 0 ? (Double(usedStorage) / Double(totalStorage)) * 100.0 : 0.0
    
    return [
      "totalStorage": totalStorage,
      "freeStorage": freeStorage,
      "usedStorage": usedStorage,
      "usagePercentage": usagePercentage
    ]
  }

  private func getMemoryInfoMap() -> [String: Any] {
    let totalRam = ProcessInfo.processInfo.physicalMemory
    var freeRam: UInt64 = 0
    
    var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
    var vmStat = vm_statistics64()
    let hostPort = mach_host_self()
    
    let result = withUnsafeMutablePointer(to: &vmStat) {
      $0.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) {
        host_statistics64(hostPort, HOST_VM_INFO64, $0, &hostSize)
      }
    }
    
    if result == KERN_SUCCESS {
      let pageSize = UInt64(vm_kernel_page_size)
      let freePages = UInt64(vmStat.free_count + vmStat.inactive_count + vmStat.speculative_count)
      freeRam = freePages * pageSize
    } else {
      freeRam = 0
    }
    
    let usedRam = totalRam > freeRam ? totalRam - freeRam : 0
    let usagePercentage = totalRam > 0 ? (Double(usedRam) / Double(totalRam)) * 100.0 : 0.0
    
    return [
      "totalRam": Int64(totalRam),
      "availableRam": Int64(freeRam),
      "usedRam": Int64(usedRam),
      "usagePercentage": usagePercentage
    ]
  }

  private func getCpuInfoMap() -> [String: Any] {
    var architecture = "unknown"
    #if arch(x86_64)
    architecture = "x86_64"
    #elseif arch(arm64)
    architecture = "arm64"
    #elseif arch(arm)
    architecture = "arm"
    #elseif arch(i386)
    architecture = "i386"
    #endif
    
    let cores = ProcessInfo.processInfo.activeProcessorCount
    
    return [
      "architecture": architecture,
      "cores": cores
    ]
  }

  private func getScreenInfoMap() -> [String: Any] {
    let screen = UIScreen.main
    let bounds = screen.bounds
    let scale = screen.scale
    let width = Int(bounds.width * scale)
    let height = Int(bounds.height * scale)
    
    var refreshRate: Double = 60.0
    if #available(iOS 10.3, *) {
      refreshRate = Double(screen.maximumFramesPerSecond)
    }
    
    return [
      "width": width,
      "height": height,
      "scale": Double(scale),
      "refreshRate": refreshRate
    ]
  }

  private func getSystemInfoMap() -> [String: Any] {
    return [
      "deviceInfo": getDeviceInfoMap(),
      "storageInfo": getStorageInfoMap(),
      "memoryInfo": getMemoryInfoMap(),
      "cpuInfo": getCpuInfoMap(),
      "screenInfo": getScreenInfoMap()
    ]
  }
}
