package com.asp.asp_chat

import io.flutter.embedding.android.FlutterActivity

/*class MainActivity : FlutterActivity()*/

// New Add For GPU RENDER Add Date : 10 sep 2025
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import com.google.firebase.crashlytics.FirebaseCrashlytics
import android.content.pm.ActivityInfo



class MainActivity : FlutterActivity() {
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
}