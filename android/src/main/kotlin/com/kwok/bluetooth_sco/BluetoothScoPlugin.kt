package com.kwok.bluetooth_sco

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BluetoothScoPlugin */
class BluetoothScoPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var audioManager: AudioManager? = null
    private var scoStarted = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_sco")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        audioManager = context?.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "isBluetoothScoAvailable" -> {
                result.success(isBluetoothScoAvailable())
            }
            "startBluetoothSco" -> {
                result.success(startBluetoothSco())
            }
            "stopBluetoothSco" -> {
                stopBluetoothSco()
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun isBluetoothScoAvailable(): Boolean {
        return try {
            audioManager?.isBluetoothScoAvailableOffCall ?: false
        } catch (e: Exception) {
            false
        }
    }

    private fun startBluetoothSco(): Boolean {
        return try {
            val am = audioManager ?: return false

            // Check if Bluetooth SCO is available
            if (!am.isBluetoothScoAvailableOffCall) {
                return false
            }

            // Don't start if already started
            if (scoStarted) {
                return true
            }

            // Set audio mode to communication
            am.mode = AudioManager.MODE_IN_COMMUNICATION

            // Start Bluetooth SCO
            am.startBluetoothSco()
            am.isBluetoothScoOn = true

            scoStarted = true
            true
        } catch (e: Exception) {
            scoStarted = false
            false
        }
    }

    private fun stopBluetoothSco() {
        try {
            val am = audioManager ?: return

            if (scoStarted) {
                am.stopBluetoothSco()
                am.isBluetoothScoOn = false
                am.mode = AudioManager.MODE_NORMAL
                scoStarted = false
            }
        } catch (e: Exception) {
            // Ignore errors - system will clean up
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Clean up SCO if still active
        stopBluetoothSco()
        channel.setMethodCallHandler(null)
        context = null
        audioManager = null
    }
}
