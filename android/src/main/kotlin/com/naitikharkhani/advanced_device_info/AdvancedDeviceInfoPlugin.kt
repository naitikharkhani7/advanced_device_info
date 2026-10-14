package com.naitikharkhani.advanced_device_info

import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Build
import android.os.Debug
import android.os.Environment
import android.os.PowerManager
import android.os.StatFs
import android.os.SystemClock
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.net.NetworkInterface

/** AdvancedDeviceInfoPlugin */
class AdvancedDeviceInfoPlugin :
    FlutterPlugin,
    MethodCallHandler {
    
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "advanced_device_info")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        try {
            when (call.method) {
                "getPlatformVersion" -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                }
                "getDeviceInfo" -> {
                    result.success(getDeviceInfoMap())
                }
                "getStorageInfo" -> {
                    result.success(getStorageInfoMap())
                }
                "getMemoryInfo" -> {
                    result.success(getMemoryInfoMap())
                }
                "getCpuInfo" -> {
                    result.success(getCpuInfoMap())
                }
                "getScreenInfo" -> {
                    result.success(getScreenInfoMap())
                }
                "getBatteryInfo" -> {
                    result.success(getBatteryInfoMap())
                }
                "getSecurityInfo" -> {
                    result.success(getSecurityInfoMap())
                }
                "getNetworkInfo" -> {
                    result.success(getNetworkInfoMap())
                }
                "getSystemInfo" -> {
                    result.success(getSystemInfoMap())
                }
                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("PLATFORM_ERROR", e.localizedMessage, e.stackTraceToString())
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    private fun getDeviceInfoMap(): Map<String, Any?> {
        val resolver = context?.contentResolver
        var deviceName = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            Settings.Global.getString(resolver, Settings.Global.DEVICE_NAME)
        } else {
            null
        }
        if (deviceName.isNullOrEmpty()) {
            deviceName = Settings.Secure.getString(resolver, "bluetooth_name")
        }
        if (deviceName.isNullOrEmpty()) {
            deviceName = Build.MODEL
        }

        val securityPatch = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Build.VERSION.SECURITY_PATCH
        } else {
            "N/A"
        }
        val radioVersion = try {
            Build.getRadioVersion() ?: "Unknown"
        } catch (e: Exception) {
            "Unknown"
        }
        val supportedAbis = Build.SUPPORTED_ABIS.joinToString(", ")
        val kernelVersion = System.getProperty("os.version") ?: "Unknown"
        val uptimeMillis = SystemClock.elapsedRealtime()

        val buildInfo = mapOf(
            "release" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "codename" to Build.VERSION.CODENAME,
            "incremental" to Build.VERSION.INCREMENTAL,
            "securityPatch" to securityPatch,
            "kernelVersion" to kernelVersion,
            "radioVersion" to radioVersion,
            "bootloader" to Build.BOOTLOADER,
            "board" to Build.BOARD,
            "supportedAbis" to supportedAbis,
            "uptimeMillis" to uptimeMillis,
            "id" to Build.ID,
            "display" to Build.DISPLAY,
            "fingerprint" to Build.FINGERPRINT,
            "hardware" to Build.HARDWARE,
            "host" to Build.HOST,
            "device" to Build.DEVICE,
            "product" to Build.PRODUCT,
            "type" to Build.TYPE,
            "tags" to Build.TAGS,
            "user" to Build.USER,
            "time" to Build.TIME
        )

        val isEmulator = (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_gphone")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator")

        return mapOf(
            "deviceName" to deviceName,
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "brand" to Build.BRAND,
            "buildInfo" to buildInfo,
            "isEmulator" to isEmulator
        )
    }

    private fun getStorageInfoMap(): Map<String, Any?> {
        val path = Environment.getDataDirectory()
        val stat = StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val totalBlocks = stat.blockCountLong
        val availableBlocks = stat.availableBlocksLong

        val totalStorage = totalBlocks * blockSize
        val freeStorage = availableBlocks * blockSize
        val usedStorage = totalStorage - freeStorage
        val usagePercentage = if (totalStorage > 0) {
            (usedStorage.toDouble() / totalStorage.toDouble()) * 100.0
        } else {
            0.0
        }

        return mapOf(
            "totalStorage" to totalStorage,
            "freeStorage" to freeStorage,
            "usedStorage" to usedStorage,
            "usagePercentage" to usagePercentage
        )
    }

    private fun getMemoryInfoMap(): Map<String, Any?> {
        val activityManager = context?.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager?.getMemoryInfo(memoryInfo)

        val totalRam = memoryInfo.totalMem
        val availableRam = memoryInfo.availMem
        val usedRam = totalRam - availableRam
        val usagePercentage = if (totalRam > 0) {
            (usedRam.toDouble() / totalRam.toDouble()) * 100.0
        } else {
            0.0
        }

        return mapOf(
            "totalRam" to totalRam,
            "availableRam" to availableRam,
            "usedRam" to usedRam,
            "usagePercentage" to usagePercentage
        )
    }

    private fun getCpuInfoMap(): Map<String, Any?> {
        val abis = Build.SUPPORTED_ABIS
        val architecture = if (abis != null && abis.isNotEmpty()) abis[0] else "unknown"
        val cores = Runtime.getRuntime().availableProcessors()

        return mapOf(
            "architecture" to architecture,
            "cores" to cores
        )
    }

    private fun getScreenInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val metrics = ctx.resources.displayMetrics
        val width = metrics.widthPixels
        val height = metrics.heightPixels
        val scale = metrics.density

        val windowManager = ctx.getSystemService(Context.WINDOW_SERVICE) as? WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try {
                ctx.display
            } catch (e: Exception) {
                @Suppress("DEPRECATION")
                windowManager?.defaultDisplay
            }
        } else {
            @Suppress("DEPRECATION")
            windowManager?.defaultDisplay
        }

        val refreshRate = display?.refreshRate?.toDouble() ?: 60.0

        return mapOf(
            "width" to width,
            "height" to height,
            "scale" to scale,
            "refreshRate" to refreshRate
        )
    }

    private fun getBatteryInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val batteryIntent = ctx.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        
        val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        val batteryLevel = if (level >= 0 && scale > 0) {
            (level * 100) / scale
        } else {
            -1
        }

        val rawStatus = batteryIntent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val isCharging = rawStatus == BatteryManager.BATTERY_STATUS_CHARGING ||
                rawStatus == BatteryManager.BATTERY_STATUS_FULL

        val batteryStatus = when (rawStatus) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "discharging"
            BatteryManager.BATTERY_STATUS_FULL -> "full"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "notCharging"
            else -> "unknown"
        }

        val plugged = batteryIntent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) ?: -1
        val powerSource = when (plugged) {
            BatteryManager.BATTERY_PLUGGED_AC -> "ac"
            BatteryManager.BATTERY_PLUGGED_USB -> "usb"
            BatteryManager.BATTERY_PLUGGED_WIRELESS -> "wireless"
            0 -> "none"
            else -> "unknown"
        }

        val rawHealth = batteryIntent?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1
        val batteryHealth = when (rawHealth) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "overheat"
            BatteryManager.BATTERY_HEALTH_DEAD -> "dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "over_voltage"
            BatteryManager.BATTERY_HEALTH_COLD -> "cold"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "unspecified_failure"
            else -> "unknown"
        }

        val rawTemp = batteryIntent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
        val batteryTemperature = rawTemp / 10.0

        val powerManager = ctx.getSystemService(Context.POWER_SERVICE) as? PowerManager
        val isLowPowerMode = powerManager?.isPowerSaveMode ?: false

        return mapOf(
            "batteryLevel" to batteryLevel,
            "isCharging" to isCharging,
            "batteryStatus" to batteryStatus,
            "powerSource" to powerSource,
            "batteryHealth" to batteryHealth,
            "batteryTemperature" to batteryTemperature,
            "isLowPowerMode" to isLowPowerMode
        )
    }

    private fun getSecurityInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val resolver = ctx.contentResolver

        // Developer mode check
        val isDeveloperMode = try {
            Settings.Global.getInt(resolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
        } catch (e: Exception) {
            false
        }

        // ADB / USB Debugging check
        val isAdbEnabled = try {
            Settings.Global.getInt(resolver, Settings.Global.ADB_ENABLED, 0) != 0
        } catch (e: Exception) {
            false
        }

        // USB cable connected check
        val usbIntent = ctx.registerReceiver(null, IntentFilter("android.hardware.usb.action.USB_STATE"))
        val usbConnectedState = usbIntent?.getBooleanExtra("connected", false) ?: false
        val batteryIntent = ctx.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val plugged = batteryIntent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) ?: -1
        val isUsbPlugged = (plugged == BatteryManager.BATTERY_PLUGGED_USB)
        val isUsbConnected = usbConnectedState || isUsbPlugged

        // Wireless debugging check (Android 11+)
        val isWirelessDebuggingEnabled = try {
            Settings.Global.getInt(resolver, "adb_wifi_enabled", 0) != 0
        } catch (e: Exception) {
            false
        }

        // Stay awake while charging (Developer option)
        val isStayAwake = try {
            Settings.Global.getInt(resolver, Settings.Global.STAY_ON_WHILE_PLUGGED_IN, 0) != 0
        } catch (e: Exception) {
            false
        }

        // Mock Location / Fake GPS detection
        val isMockLocation = try {
            @Suppress("DEPRECATION")
            val setting = Settings.Secure.getString(resolver, Settings.Secure.ALLOW_MOCK_LOCATION)
            setting != null && setting != "0"
        } catch (e: Exception) {
            false
        }

        // Verification of apps over USB
        val isVerificationOfAppsOverUsb = try {
            Settings.Global.getInt(resolver, Settings.Global.PACKAGE_VERIFIER_USER_CONSENT, 0) != 0
        } catch (e: Exception) {
            false
        }

        // Device lock / passcode check
        val km = ctx.getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        val isDeviceSecure = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            km?.isDeviceSecure ?: false
        } else {
            @Suppress("DEPRECATION")
            km?.isKeyguardSecure ?: false
        }

        // Debugger attached
        val isDebuggerAttached = Debug.isDebuggerConnected()

        // Root Detection
        val isRooted = checkRootMethod1() || checkRootMethod2() || checkRootMethod3()

        return mapOf(
            "isRooted" to isRooted,
            "isJailbroken" to false,
            "isDeveloperMode" to isDeveloperMode,
            "isAdbEnabled" to isAdbEnabled,
            "isWirelessDebuggingEnabled" to isWirelessDebuggingEnabled,
            "isStayAwake" to isStayAwake,
            "isMockLocation" to isMockLocation,
            "isVerificationOfAppsOverUsb" to isVerificationOfAppsOverUsb,
            "isUsbConnected" to isUsbConnected,
            "isDeviceSecure" to isDeviceSecure,
            "isDebuggerAttached" to isDebuggerAttached
        )
    }

    private fun checkRootMethod1(): Boolean {
        val buildTags = Build.TAGS
        return buildTags != null && buildTags.contains("test-keys")
    }

    private fun checkRootMethod2(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
            "/su/bin/su",
            "/system/xbin/daemonsu"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        return false
    }

    private fun checkRootMethod3(): Boolean {
        var process: java.lang.Process? = null
        return try {
            process = Runtime.getRuntime().exec(arrayOf("/system/xbin/which", "su"))
            val reader = process.inputStream.bufferedReader()
            reader.readLine() != null
        } catch (t: Throwable) {
            false
        } finally {
            process?.destroy()
        }
    }

    private fun getNetworkInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        
        var isConnected = false
        var connectionType = "none"
        var isVpn = false

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val activeNetwork = cm?.activeNetwork
            val caps = cm?.getNetworkCapabilities(activeNetwork)
            if (caps != null) {
                isConnected = caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                isVpn = caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
                connectionType = when {
                    caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
                    caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
                    caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
                    caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN) -> "vpn"
                    else -> "unknown"
                }
            }
        } else {
            @Suppress("DEPRECATION")
            val netInfo = cm?.activeNetworkInfo
            @Suppress("DEPRECATION")
            if (netInfo != null && netInfo.isConnected) {
                isConnected = true
                @Suppress("DEPRECATION")
                connectionType = when (netInfo.type) {
                    ConnectivityManager.TYPE_WIFI -> "wifi"
                    ConnectivityManager.TYPE_MOBILE -> "cellular"
                    ConnectivityManager.TYPE_ETHERNET -> "ethernet"
                    ConnectivityManager.TYPE_VPN -> "vpn"
                    else -> "unknown"
                }
            }
        }

        // Secondary VPN check via active network interfaces (tun, ppp, tap)
        if (!isVpn) {
            try {
                val interfaces = NetworkInterface.getNetworkInterfaces()
                while (interfaces != null && interfaces.hasMoreElements()) {
                    val networkInterface = interfaces.nextElement()
                    val name = networkInterface.name.lowercase()
                    if (networkInterface.isUp && (name.contains("tun") || name.contains("ppp") || name.contains("p2p") || name.contains("tap"))) {
                        isVpn = true
                        break
                    }
                }
            } catch (e: Exception) {
                // Ignore interface error
            }
        }

        return mapOf(
            "isConnected" to isConnected,
            "connectionType" to connectionType,
            "isVpnActive" to isVpn
        )
    }

    private fun getSystemInfoMap(): Map<String, Any?> {
        return mapOf(
            "deviceInfo" to getDeviceInfoMap(),
            "storageInfo" to getStorageInfoMap(),
            "memoryInfo" to getMemoryInfoMap(),
            "cpuInfo" to getCpuInfoMap(),
            "screenInfo" to getScreenInfoMap(),
            "batteryInfo" to getBatteryInfoMap(),
            "securityInfo" to getSecurityInfoMap(),
            "networkInfo" to getNetworkInfoMap()
        )
    }
}
