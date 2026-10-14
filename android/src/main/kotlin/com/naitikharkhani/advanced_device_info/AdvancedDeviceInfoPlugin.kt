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
import android.hardware.Sensor
import android.hardware.SensorManager
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.media.MediaDrm
import android.net.wifi.WifiManager
import android.nfc.NfcAdapter
import android.bluetooth.BluetoothAdapter
import android.content.res.Configuration
import android.os.LocaleList
import android.os.Vibrator
import android.os.VibratorManager
import android.telephony.TelephonyManager
import android.view.Display
import android.view.accessibility.AccessibilityManager
import java.io.File
import java.net.NetworkInterface
import android.text.format.DateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import java.util.UUID

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
                "getDrmInfo" -> {
                    result.success(getDrmInfoMap())
                }
                "getBiometricInfo" -> {
                    result.success(getBiometricInfoMap())
                }
                "getSensorsInfo" -> {
                    result.success(getSensorsInfoMap())
                }
                "getLiveHardwareInfo" -> {
                    result.success(getLiveHardwareInfoMap())
                }
                "getThermalInfo" -> {
                    result.success(getThermalInfoMap())
                }
                "getDisplayCapabilitiesInfo" -> {
                    result.success(getDisplayCapabilitiesInfoMap())
                }
                "getPeripheralsInfo" -> {
                    result.success(getPeripheralsInfoMap())
                }
                "getAudioVolumeInfo" -> {
                    result.success(getAudioVolumeInfoMap())
                }
                "getLocaleThemeInfo" -> {
                    result.success(getLocaleThemeInfoMap())
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
            Settings.Global.getInt(resolver, "package_verifier_user_consent", 0) != 0
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

    private fun getDrmInfoMap(): Map<String, Any?> {
        var securityLevel = "N/A"
        var vendor = "Unknown"
        var version = "Unknown"
        var systemId = -1

        try {
            val widevineUuid = UUID(-0x121074568629b532L, -0x5c37d8232ae2de13L)
            if (MediaDrm.isCryptoSchemeSupported(widevineUuid)) {
                val mediaDrm = MediaDrm(widevineUuid)
                try {
                    vendor = mediaDrm.getPropertyString(MediaDrm.PROPERTY_VENDOR)
                    version = mediaDrm.getPropertyString(MediaDrm.PROPERTY_VERSION)
                    securityLevel = mediaDrm.getPropertyString("securityLevel")
                    systemId = mediaDrm.getPropertyString("systemId")?.toIntOrNull() ?: -1
                } catch (e: Exception) {
                    securityLevel = "L3"
                } finally {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        mediaDrm.close()
                    } else {
                        @Suppress("DEPRECATION")
                        mediaDrm.release()
                    }
                }
            }
        } catch (e: Exception) {
            // DRM query not supported
        }

        return mapOf(
            "widevineSecurityLevel" to securityLevel,
            "widevineVendor" to vendor,
            "widevineVersion" to version,
            "systemId" to systemId
        )
    }

    private fun getBiometricInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val types = mutableListOf<String>()

        val pm = ctx.packageManager
        val hasFingerprint = pm.hasSystemFeature(android.content.pm.PackageManager.FEATURE_FINGERPRINT)
        val hasFace = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            pm.hasSystemFeature(android.content.pm.PackageManager.FEATURE_FACE)
        } else false
        val hasIris = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            pm.hasSystemFeature(android.content.pm.PackageManager.FEATURE_IRIS)
        } else false

        if (hasFingerprint) types.add("fingerprint")
        if (hasFace) types.add("face")
        if (hasIris) types.add("iris")

        val km = ctx.getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        val isEnrolled = km?.isDeviceSecure ?: false

        return mapOf(
            "hasBiometrics" to types.isNotEmpty(),
            "isEnrolled" to isEnrolled,
            "supportedTypes" to types
        )
    }

    private fun getSensorsInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val sm = ctx.getSystemService(Context.SENSOR_SERVICE) as? SensorManager ?: return emptyMap()

        val hasAccelerometer = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) != null
        val hasGyroscope = sm.getDefaultSensor(Sensor.TYPE_GYROSCOPE) != null
        val hasBarometer = sm.getDefaultSensor(Sensor.TYPE_PRESSURE) != null
        val hasMagnetometer = sm.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) != null
        val hasProximity = sm.getDefaultSensor(Sensor.TYPE_PROXIMITY) != null
        val hasStepCounter = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null
        val hasLight = sm.getDefaultSensor(Sensor.TYPE_LIGHT) != null

        val allSensors = sm.getSensorList(Sensor.TYPE_ALL).map { it.name }

        return mapOf(
            "hasAccelerometer" to hasAccelerometer,
            "hasGyroscope" to hasGyroscope,
            "hasBarometer" to hasBarometer,
            "hasMagnetometer" to hasMagnetometer,
            "hasProximity" to hasProximity,
            "hasStepCounter" to hasStepCounter,
            "hasLight" to hasLight,
            "totalSensorCount" to allSensors.size,
            "sensorNames" to allSensors.take(25)
        )
    }

    private fun getLiveHardwareInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()

        val pm = ctx.getSystemService(Context.POWER_SERVICE) as? PowerManager
        val isScreenOn = pm?.isInteractive ?: true

        val wm = ctx.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
        val isWifiEnabled = try {
            wm?.isWifiEnabled ?: false
        } catch (e: Exception) {
            false
        }

        val am = ctx.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        val isCallActive = (am?.mode == AudioManager.MODE_IN_CALL || am?.mode == AudioManager.MODE_IN_COMMUNICATION)

        val isHeadphonesConnected = try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val devices = am?.getDevices(AudioManager.GET_DEVICES_OUTPUTS) ?: emptyArray()
                devices.any {
                    it.type == AudioDeviceInfo.TYPE_WIRED_HEADSET ||
                    it.type == AudioDeviceInfo.TYPE_WIRED_HEADPHONES ||
                    it.type == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP ||
                    it.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
                }
            } else {
                @Suppress("DEPRECATION")
                (am?.isWiredHeadsetOn == true || am?.isBluetoothA2dpOn == true)
            }
        } catch (e: Exception) {
            false
        }

        val tm = ctx.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
        val simSlotCount = try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                tm?.activeModemCount ?: 1
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                @Suppress("DEPRECATION")
                tm?.phoneCount ?: 1
            } else {
                1
            }
        } catch (e: Exception) {
            1
        }

        return mapOf(
            "isScreenOn" to isScreenOn,
            "isWifiEnabled" to isWifiEnabled,
            "isCallActive" to isCallActive,
            "isHeadphonesConnected" to isHeadphonesConnected,
            "simSlotCount" to simSlotCount
        )
    }

    private fun getThermalInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val pm = ctx.getSystemService(Context.POWER_SERVICE) as? PowerManager

        val thermalStatus = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && pm != null) {
            when (pm.currentThermalStatus) {
                PowerManager.THERMAL_STATUS_NONE -> "NONE"
                PowerManager.THERMAL_STATUS_LIGHT -> "LIGHT"
                PowerManager.THERMAL_STATUS_MODERATE -> "MODERATE"
                PowerManager.THERMAL_STATUS_SEVERE -> "SEVERE"
                PowerManager.THERMAL_STATUS_CRITICAL -> "CRITICAL"
                PowerManager.THERMAL_STATUS_EMERGENCY -> "EMERGENCY"
                PowerManager.THERMAL_STATUS_SHUTDOWN -> "SHUTDOWN"
                else -> "UNKNOWN"
            }
        } else {
            "NONE"
        }

        val isPowerSaveMode = pm?.isPowerSaveMode ?: false
        val isDeviceIdleMode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            pm?.isDeviceIdleMode ?: false
        } else {
            false
        }

        return mapOf(
            "thermalStatus" to thermalStatus,
            "isPowerSaveMode" to isPowerSaveMode,
            "isDeviceIdleMode" to isDeviceIdleMode
        )
    }

    private fun getDisplayCapabilitiesInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val wm = ctx.getSystemService(Context.WINDOW_SERVICE) as? WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try { ctx.display } catch (e: Exception) { wm?.defaultDisplay }
        } else {
            @Suppress("DEPRECATION")
            wm?.defaultDisplay
        }

        var isHdr = false
        val hdrTypes = mutableListOf<String>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N && display != null) {
            try {
                val caps = display.hdrCapabilities
                if (caps != null && caps.supportedHdrTypes.isNotEmpty()) {
                    isHdr = true
                    for (t in caps.supportedHdrTypes) {
                        when (t) {
                            Display.HdrCapabilities.HDR_TYPE_HDR10 -> hdrTypes.add("HDR10")
                            Display.HdrCapabilities.HDR_TYPE_DOLBY_VISION -> hdrTypes.add("DOLBY_VISION")
                            Display.HdrCapabilities.HDR_TYPE_HLG -> hdrTypes.add("HLG")
                            4 -> hdrTypes.add("HDR10_PLUS")
                            else -> hdrTypes.add("HDR_TYPE_$t")
                        }
                    }
                }
            } catch (e: Exception) {
                // Ignore HDR query error
            }
        }

        val isWideGamut = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && display != null) {
            try { display.isWideColorGamut } catch (e: Exception) { false }
        } else {
            false
        }

        val rates = mutableListOf<Double>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && display != null) {
            try {
                for (mode in display.supportedModes) {
                    val rounded = Math.round(mode.refreshRate.toDouble() * 10.0) / 10.0
                    if (!rates.contains(rounded)) {
                        rates.add(rounded)
                    }
                }
            } catch (e: Exception) {
                // Ignore supported modes error
            }
        }
        if (rates.isEmpty() && display != null) {
            @Suppress("DEPRECATION")
            rates.add(Math.round(display.refreshRate.toDouble() * 10.0) / 10.0)
        }

        val resolver = ctx.contentResolver
        val brightness = try {
            Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS, -1)
        } catch (e: Exception) {
            -1
        }
        val isAutoBrightness = try {
            Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS_MODE, 0) == Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC
        } catch (e: Exception) {
            false
        }

        return mapOf(
            "isHdrSupported" to isHdr,
            "supportedHdrTypes" to hdrTypes,
            "isWideColorGamut" to isWideGamut,
            "supportedRefreshRates" to rates,
            "screenBrightness" to brightness,
            "isAutoBrightnessEnabled" to isAutoBrightness
        )
    }

    private fun getPeripheralsInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()

        val nfcAdapter = try {
            NfcAdapter.getDefaultAdapter(ctx)
        } catch (e: Exception) {
            null
        }
        val isNfcAvailable = nfcAdapter != null
        val isNfcEnabled = try { nfcAdapter?.isEnabled ?: false } catch (e: Exception) { false }

        val btAdapter = try {
            @Suppress("DEPRECATION")
            BluetoothAdapter.getDefaultAdapter()
        } catch (e: Exception) {
            null
        }
        val isBtAvailable = btAdapter != null
        val isBtEnabled = try { btAdapter?.isEnabled ?: false } catch (e: Exception) { false }

        var totalCameras = 0
        var frontCameras = 0
        var backCameras = 0
        var hasFlashlight = false

        try {
            val cm = ctx.getSystemService(Context.CAMERA_SERVICE) as? CameraManager
            if (cm != null) {
                val ids = cm.cameraIdList
                totalCameras = ids.size
                for (id in ids) {
                    val chars = cm.getCameraCharacteristics(id)
                    val facing = chars.get(CameraCharacteristics.LENS_FACING)
                    if (facing == CameraCharacteristics.LENS_FACING_FRONT) {
                        frontCameras++
                    } else if (facing == CameraCharacteristics.LENS_FACING_BACK) {
                        backCameras++
                    }
                    val flashAvailable = chars.get(CameraCharacteristics.FLASH_INFO_AVAILABLE)
                    if (flashAvailable == true) {
                        hasFlashlight = true
                    }
                }
            }
        } catch (e: Exception) {
            // Camera enumeration not supported or failed
        }
        if (!hasFlashlight) {
            hasFlashlight = ctx.packageManager.hasSystemFeature(android.content.pm.PackageManager.FEATURE_CAMERA_FLASH)
        }

        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vm = ctx.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
            vm?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            ctx.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }
        val hasVibrator = vibrator?.hasVibrator() ?: false
        val hasAmplitudeControl = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator?.hasAmplitudeControl() ?: false
        } else {
            false
        }

        return mapOf(
            "isNfcAvailable" to isNfcAvailable,
            "isNfcEnabled" to isNfcEnabled,
            "isBluetoothAvailable" to isBtAvailable,
            "isBluetoothEnabled" to isBtEnabled,
            "hasFlashlight" to hasFlashlight,
            "cameraCount" to totalCameras,
            "frontCameraCount" to frontCameras,
            "backCameraCount" to backCameras,
            "hasVibrator" to hasVibrator,
            "hasAmplitudeControl" to hasAmplitudeControl
        )
    }

    private fun getAudioVolumeInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()
        val am = ctx.getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return emptyMap()

        val mediaVol = try { am.getStreamVolume(AudioManager.STREAM_MUSIC) } catch (e: Exception) { 0 }
        val maxMediaVol = try { am.getStreamMaxVolume(AudioManager.STREAM_MUSIC) } catch (e: Exception) { 0 }

        val ringVol = try { am.getStreamVolume(AudioManager.STREAM_RING) } catch (e: Exception) { 0 }
        val maxRingVol = try { am.getStreamMaxVolume(AudioManager.STREAM_RING) } catch (e: Exception) { 0 }

        val callVol = try { am.getStreamVolume(AudioManager.STREAM_VOICE_CALL) } catch (e: Exception) { 0 }
        val maxCallVol = try { am.getStreamMaxVolume(AudioManager.STREAM_VOICE_CALL) } catch (e: Exception) { 0 }

        val alarmVol = try { am.getStreamVolume(AudioManager.STREAM_ALARM) } catch (e: Exception) { 0 }
        val maxAlarmVol = try { am.getStreamMaxVolume(AudioManager.STREAM_ALARM) } catch (e: Exception) { 0 }

        val notifVol = try { am.getStreamVolume(AudioManager.STREAM_NOTIFICATION) } catch (e: Exception) { 0 }
        val maxNotifVol = try { am.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION) } catch (e: Exception) { 0 }

        val isMicMute = try { am.isMicrophoneMute } catch (e: Exception) { false }
        val isA2dp = try {
            @Suppress("DEPRECATION")
            am.isBluetoothA2dpOn
        } catch (e: Exception) {
            false
        }

        return mapOf(
            "mediaVolume" to mediaVol,
            "maxMediaVolume" to maxMediaVol,
            "ringVolume" to ringVol,
            "maxRingVolume" to maxRingVol,
            "callVolume" to callVol,
            "maxCallVolume" to maxCallVol,
            "alarmVolume" to alarmVol,
            "maxAlarmVolume" to maxAlarmVol,
            "notificationVolume" to notifVol,
            "maxNotificationVolume" to maxNotifVol,
            "isMicrophoneMute" to isMicMute,
            "isBluetoothA2dpOn" to isA2dp
        )
    }

    private fun getLocaleThemeInfoMap(): Map<String, Any?> {
        val ctx = context ?: return emptyMap()

        val tz = TimeZone.getDefault()
        val tzId = tz.id ?: "UTC"
        val tzName = tz.getDisplayName(tz.inDaylightTime(Date()), TimeZone.SHORT) ?: tzId
        val tzOffset = (tz.rawOffset + (if (tz.inDaylightTime(Date())) tz.dstSavings else 0)) / 1000

        val preferredLanguages = mutableListOf<String>()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val list = LocaleList.getDefault()
            for (i in 0 until list.size()) {
                preferredLanguages.add(list.get(i).toLanguageTag())
            }
        } else {
            preferredLanguages.add(Locale.getDefault().toLanguageTag())
        }

        val is24Hour = try {
            DateFormat.is24HourFormat(ctx)
        } catch (e: Exception) {
            false
        }

        val fontScale = ctx.resources.configuration.fontScale.toDouble()

        val am = ctx.getSystemService(Context.ACCESSIBILITY_SERVICE) as? AccessibilityManager
        val isScreenReader = try {
            am?.isTouchExplorationEnabled ?: false
        } catch (e: Exception) {
            false
        }

        val currentNightMode = ctx.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
        val isDarkMode = currentNightMode == Configuration.UI_MODE_NIGHT_YES

        return mapOf(
            "timezoneId" to tzId,
            "timezoneDisplayName" to tzName,
            "timezoneOffsetSeconds" to tzOffset,
            "preferredLanguages" to preferredLanguages,
            "is24HourFormat" to is24Hour,
            "fontScale" to fontScale,
            "isScreenReaderActive" to isScreenReader,
            "isDarkMode" to isDarkMode
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
            "networkInfo" to getNetworkInfoMap(),
            "drmInfo" to getDrmInfoMap(),
            "biometricInfo" to getBiometricInfoMap(),
            "sensorsInfo" to getSensorsInfoMap(),
            "liveHardwareInfo" to getLiveHardwareInfoMap(),
            "thermalInfo" to getThermalInfoMap(),
            "displayCapabilitiesInfo" to getDisplayCapabilitiesInfoMap(),
            "peripheralsInfo" to getPeripheralsInfoMap(),
            "audioVolumeInfo" to getAudioVolumeInfoMap(),
            "localeThemeInfo" to getLocaleThemeInfoMap()
        )
    }
}

