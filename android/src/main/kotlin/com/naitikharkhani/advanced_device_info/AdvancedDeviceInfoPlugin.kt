package com.naitikharkhani.advanced_device_info

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

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

        val buildInfo = mapOf(
            "release" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "id" to Build.ID,
            "display" to Build.DISPLAY,
            "fingerprint" to Build.FINGERPRINT,
            "hardware" to Build.HARDWARE,
            "host" to Build.HOST,
            "device" to Build.DEVICE,
            "product" to Build.PRODUCT,
            "type" to Build.TYPE
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

    private fun getSystemInfoMap(): Map<String, Any?> {
        return mapOf(
            "deviceInfo" to getDeviceInfoMap(),
            "storageInfo" to getStorageInfoMap(),
            "memoryInfo" to getMemoryInfoMap(),
            "cpuInfo" to getCpuInfoMap(),
            "screenInfo" to getScreenInfoMap()
        )
    }
}
