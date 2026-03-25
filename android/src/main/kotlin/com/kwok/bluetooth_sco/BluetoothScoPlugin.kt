package com.kwok.bluetooth_sco

import android.content.Context
import android.media.AudioManager
import android.os.Build
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
            "isBluetoothScoAvailable" -> result.success(isBluetoothScoAvailable())
            "startBluetoothSco"       -> startBluetoothSco(result)
            "stopBluetoothSco"        -> stopBluetoothSco(result)
            else                      -> result.notImplemented()
        }
    }

    // ─────────────────────────── helpers ────────────────────────────

    /** Returns true when a Bluetooth SCO/headset device is connected and available. */
    private fun isBluetoothScoAvailable(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // API 31+: query communication device list (no BT permission required)
            audioManager.availableCommunicationDevices.any { device ->
                device.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
            }
        } else {
            @Suppress("DEPRECATION")
            val adapter = BluetoothAdapter.getDefaultAdapter()
            adapter != null &&
                    adapter.isEnabled &&
                    audioManager.isBluetoothScoAvailableOffCall
        }
    }

    /**
     * Activates Bluetooth SCO so Android routes the microphone input to the
     * headset. On API 31+ this uses the new setCommunicationDevice() API;
     * on older versions it uses the deprecated startBluetoothSco() path.
     */
    private fun startBluetoothSco(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val btDevice = audioManager.availableCommunicationDevices.firstOrNull {
                    it.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
                }
                if (btDevice != null) {
                    val success = audioManager.setCommunicationDevice(btDevice)
                    result.success(success)
                } else {
                    result.success(false)
                }
            } else {
                @Suppress("DEPRECATION")
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                @Suppress("DEPRECATION")
                audioManager.startBluetoothSco()
                @Suppress("DEPRECATION")
                audioManager.isBluetoothScoOn = true
                result.success(true)
            }
        } catch (e: Exception) {
            result.error("BT_SCO_START_ERROR", e.message, null)
        }
    }

    /**
     * Deactivates Bluetooth SCO and restores normal audio mode.
     */
    private fun stopBluetoothSco(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                audioManager.clearCommunicationDevice()
            } else {
                @Suppress("DEPRECATION")
                audioManager.stopBluetoothSco()
                @Suppress("DEPRECATION")
                audioManager.isBluetoothScoOn = false
                @Suppress("DEPRECATION")
                audioManager.mode = AudioManager.MODE_NORMAL
            }
            result.success(true)
        } catch (e: Exception) {
            result.error("BT_SCO_STOP_ERROR", e.message, null)
        }
    }

    /** Ensure SCO is cleaned up if the activity is destroyed while recording. */

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Clean up SCO if still active
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                audioManager.clearCommunicationDevice()
            } else {
                @Suppress("DEPRECATION")
                audioManager.stopBluetoothSco()
                @Suppress("DEPRECATION")
                audioManager.isBluetoothScoOn = false
                @Suppress("DEPRECATION")
                audioManager.mode = AudioManager.MODE_NORMAL
            }
        } catch (_: Exception) {}
        channel.setMethodCallHandler(null)
        context = null
        audioManager = null
    }
}
