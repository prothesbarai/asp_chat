package com.asp.asp_chat

import io.flutter.embedding.android.FlutterActivity

/*class MainActivity : FlutterActivity()*/


// New Add For GPU RENDER Add Date : 10 sep 2025
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import com.google.firebase.crashlytics.FirebaseCrashlytics
import android.content.pm.ActivityInfo

// >>> For Alarm Set Purpose ========================
import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
// <<< For Alarm Set Purpose ========================


class MainActivity : FlutterActivity() {

    // >>> For Alarm Set Purpose ===================================================================
    private val CHANNEL = "exact_alarm_permission"
    // <<< For Alarm Set Purpose ===================================================================

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //  Lock portrait
        requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT

        // known crash GPU brands list
        val badGpuVendors = listOf("powervr", "rogue", "mali", "vivante", "imagination", "mtk")
        // device manufacturers (brand) this devices crush rate high
        val badManufacturers =
            listOf("symphony", "walton", "tecno", "infinix", "itel", "lava", "karbonn", "micromax")

        // Get processor / GPU type from device
        val gpuRenderer = Build.HARDWARE.lowercase()
        // Get device manufacturers (brand)
        val manufacturer = Build.MANUFACTURER.lowercase()

        val isBadDevice = badGpuVendors.any { gpuRenderer.contains(it) } || badManufacturers.any {
            manufacturer.contains(it)
        }

        val crashlytics = FirebaseCrashlytics.getInstance()
        crashlytics.setCustomKey("GPU_Renderer", gpuRenderer)
        crashlytics.setCustomKey("Manufacturer", manufacturer)
        crashlytics.setCustomKey("HardwareAccelerationEnabled", !isBadDevice)

        if (!isBadDevice) {
            // Good Device → enable GPU
            window.setFlags(
                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
            )
        } else {
            // Bad → CPU fallback
            window.clearFlags(WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED)
        }
    }

    // >>> For Alarm Set Purpose ===================================================================
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "canScheduleExactAlarms" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val alarmManager =
                            getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        result.success(alarmManager.canScheduleExactAlarms())
                    } else {
                        result.success(true)
                    }
                }

                "requestExactAlarm" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val intent =
                            Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        startActivity(intent)
                    }
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
    // <<< For Alarm Set Purpose ===================================================================


}