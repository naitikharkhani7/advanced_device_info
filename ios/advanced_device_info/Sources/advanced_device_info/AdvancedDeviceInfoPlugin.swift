import Flutter
import UIKit
import Darwin
import LocalAuthentication
import SystemConfiguration
import AVFoundation
import CoreMotion

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
    case "getBatteryInfo":
      result(getBatteryInfoMap())
    case "getSecurityInfo":
      result(getSecurityInfoMap())
    case "getNetworkInfo":
      result(getNetworkInfoMap())
    case "getSystemInfo":
      result(getSystemInfoMap())
    case "getDrmInfo":
      result(getDrmInfoMap())
    case "getBiometricInfo":
      result(getBiometricInfoMap())
    case "getSensorsInfo":
      result(getSensorsInfoMap())
    case "getLiveHardwareInfo":
      result(getLiveHardwareInfoMap())
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
    
    var uts = utsname()
    uname(&uts)
    let kernelVersion = withUnsafePointer(to: &uts.release) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
        String(cString: ptr)
      }
    }
    
    let uptimeSeconds = ProcessInfo.processInfo.systemUptime
    let activeProcessorCount = ProcessInfo.processInfo.activeProcessorCount
    
    let thermalStateStr: String
    switch ProcessInfo.processInfo.thermalState {
    case .nominal: thermalStateStr = "nominal"
    case .fair: thermalStateStr = "fair"
    case .serious: thermalStateStr = "serious"
    case .critical: thermalStateStr = "critical"
    @unknown default: thermalStateStr = "unknown"
    }
    
    let buildInfo: [String: Any] = [
      "systemName": device.systemName,
      "systemVersion": device.systemVersion,
      "modelIdentifier": modelIdentifier,
      "localizedModel": device.localizedModel,
      "identifierForVendor": device.identifierForVendor?.uuidString ?? "",
      "kernelVersion": kernelVersion,
      "uptimeSeconds": uptimeSeconds,
      "activeProcessorCount": activeProcessorCount,
      "thermalState": thermalStateStr
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

  private func getBatteryInfoMap() -> [String: Any] {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    
    let rawLevel = device.batteryLevel
    let batteryLevel = rawLevel >= 0 ? Int(round(rawLevel * 100)) : -1
    
    let state = device.batteryState
    let isCharging = (state == .charging || state == .full)
    let batteryStatus: String
    switch state {
    case .charging:
      batteryStatus = "charging"
    case .full:
      batteryStatus = "full"
    case .unplugged:
      batteryStatus = "discharging"
    default:
      batteryStatus = "unknown"
    }

    let powerSource = isCharging ? "ac" : (state == .unplugged ? "none" : "unknown")
    let isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled

    return [
      "batteryLevel": batteryLevel,
      "isCharging": isCharging,
      "batteryStatus": batteryStatus,
      "powerSource": powerSource,
      "batteryHealth": "good",
      "batteryTemperature": 0.0,
      "isLowPowerMode": isLowPowerMode
    ]
  }

  private func getSecurityInfoMap() -> [String: Any] {
    let isJailbroken = checkJailbreak()
    let isDebuggerAttached = checkDebuggerAttached()
    
    // Check if passcode/biometrics is configured on device
    let context = LAContext()
    var error: NSError?
    let isDeviceSecure = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)

    // USB connected check (on iOS, charging state implies cable connected)
    let batteryState = UIDevice.current.batteryState
    let isUsbConnected = (batteryState == .charging || batteryState == .full)

    return [
      "isRooted": false,
      "isJailbroken": isJailbroken,
      "isDeveloperMode": false,
      "isAdbEnabled": false,
      "isWirelessDebuggingEnabled": false,
      "isStayAwake": false,
      "isMockLocation": false,
      "isVerificationOfAppsOverUsb": false,
      "isUsbConnected": isUsbConnected,
      "isDeviceSecure": isDeviceSecure,
      "isDebuggerAttached": isDebuggerAttached
    ]
  }

  private func checkJailbreak() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #else
    let fileManager = FileManager.default
    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt",
      "/usr/bin/ssh",
      "/private/var/lib/apt/",
      "/private/var/lib/cydia",
      "/private/var/tmp/cydia.log"
    ]
    for path in paths {
      if fileManager.fileExists(atPath: path) {
        return true
      }
    }

    // Sandbox check: try to write outside sandbox
    let testString = "JailbreakTest"
    let testPath = "/private/jailbreak_test_\(UUID().uuidString).txt"
    do {
      try testString.write(toFile: testPath, atomically: true, encoding: .utf8)
      try? fileManager.removeItem(atPath: testPath)
      return true
    } catch {
      // Expected behavior on non-jailbroken device
    }

    return false
    #endif
  }

  private func checkDebuggerAttached() -> Bool {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.stride
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
  }

  private func getNetworkInfoMap() -> [String: Any] {
    var isConnected = false
    var connectionType = "none"
    var isVpn = false

    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    if getifaddrs(&ifaddr) == 0 {
      var ptr = ifaddr
      while ptr != nil {
        guard let interface = ptr?.pointee else { break }
        let name = String(cString: interface.ifa_name)
        let flags = Int32(interface.ifa_flags)
        
        let isUp = (flags & IFF_UP) == IFF_UP
        let isRunning = (flags & IFF_RUNNING) == IFF_RUNNING
        let isLoopback = (flags & IFF_LOOPBACK) == IFF_LOOPBACK

        if isUp && isRunning && !isLoopback {
          isConnected = true
          if name.hasPrefix("en0") {
            connectionType = "wifi"
          } else if name.hasPrefix("pdp_ip") {
            if connectionType != "wifi" {
              connectionType = "cellular"
            }
          }
          if name.hasPrefix("tun") || name.hasPrefix("tap") || name.hasPrefix("ppp") || name.hasPrefix("ipsec") {
            isVpn = true
          }
        }
        ptr = interface.ifa_next
      }
      freeifaddrs(ifaddr)
    }

    // Secondary VPN check via proxy settings dictionary
    if !isVpn, let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
       let scoped = proxySettings["__SCOPED__"] as? [String: Any] {
      for key in scoped.keys {
        if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
          isVpn = true
          break
        }
      }
    }

    return [
      "isConnected": isConnected,
      "connectionType": isVpn ? "vpn" : connectionType,
      "isVpnActive": isVpn
    ]
  }

  private func getDrmInfoMap() -> [String: Any] {
    return [
      "widevineSecurityLevel": "N/A (FairPlay)",
      "widevineVendor": "Apple Inc.",
      "widevineVersion": "FairPlay Streaming",
      "systemId": -1
    ]
  }

  private func getBiometricInfoMap() -> [String: Any] {
    let context = LAContext()
    var error: NSError?
    let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    var types: [String] = []
    if #available(iOS 11.0, *) {
      switch context.biometryType {
      case .faceID:
        types.append("face")
      case .touchID:
        types.append("fingerprint")
      case .opticID:
        types.append("optic")
      default:
        break
      }
    }
    return [
      "hasBiometrics": !types.isEmpty,
      "isEnrolled": canEvaluate,
      "supportedTypes": types
    ]
  }

  private func getSensorsInfoMap() -> [String: Any] {
    let motionManager = CMMotionManager()
    let hasAccelerometer = motionManager.isAccelerometerAvailable
    let hasGyroscope = motionManager.isGyroAvailable
    let hasMagnetometer = motionManager.isMagnetometerAvailable
    let hasBarometer = CMAltimeter.isRelativeAltitudeAvailable()
    let hasStepCounter = CMPedometer.isStepCountingAvailable()

    var names: [String] = []
    if hasAccelerometer { names.append("Accelerometer") }
    if hasGyroscope { names.append("Gyroscope") }
    if hasMagnetometer { names.append("Magnetometer") }
    if hasBarometer { names.append("Barometer (Altimeter)") }
    if hasStepCounter { names.append("Step Counter (Pedometer)") }
    names.append("Proximity Sensor")
    names.append("Ambient Light Sensor")

    return [
      "hasAccelerometer": hasAccelerometer,
      "hasGyroscope": hasGyroscope,
      "hasBarometer": hasBarometer,
      "hasMagnetometer": hasMagnetometer,
      "hasProximity": true,
      "hasStepCounter": hasStepCounter,
      "hasLight": true,
      "totalSensorCount": names.count,
      "sensorNames": names
    ]
  }

  private func getLiveHardwareInfoMap() -> [String: Any] {
    let session = AVAudioSession.sharedInstance()
    var isHeadphones = false
    for output in session.currentRoute.outputs {
      if output.portType == .headphones || output.portType == .bluetoothA2DP || output.portType == .bluetoothHFP || output.portType == .bluetoothLE {
        isHeadphones = true
        break
      }
    }
    let isCall = (session.category == .playAndRecord || session.category == .record)
    let isScreenOn = (UIScreen.main.brightness > 0.0)

    return [
      "isScreenOn": isScreenOn,
      "isWifiEnabled": true,
      "isCallActive": isCall,
      "isHeadphonesConnected": isHeadphones,
      "simSlotCount": 2
    ]
  }

  private func getSystemInfoMap() -> [String: Any] {
    return [
      "deviceInfo": getDeviceInfoMap(),
      "storageInfo": getStorageInfoMap(),
      "memoryInfo": getMemoryInfoMap(),
      "cpuInfo": getCpuInfoMap(),
      "screenInfo": getScreenInfoMap(),
      "batteryInfo": getBatteryInfoMap(),
      "securityInfo": getSecurityInfoMap(),
      "networkInfo": getNetworkInfoMap(),
      "drmInfo": getDrmInfoMap(),
      "biometricInfo": getBiometricInfoMap(),
      "sensorsInfo": getSensorsInfoMap(),
      "liveHardwareInfo": getLiveHardwareInfoMap()
    ]
  }
}
