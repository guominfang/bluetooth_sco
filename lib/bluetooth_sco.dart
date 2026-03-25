
import 'dart:io';

import 'bluetooth_sco_platform_interface.dart';

/// Manages Bluetooth SCO (Synchronous Connection Oriented) audio routing on Android.
///
/// Bluetooth headsets connect in A2DP mode by default (audio output only).
/// To record from the headset microphone, the system must be switched to SCO /
/// HFP mode via [startBluetoothSco] before the recorder starts.
///
/// iOS handles Bluetooth audio routing automatically — no action needed there.
class BluetoothSco {
  /// Returns `true` if a Bluetooth SCO/headset device is currently connected
  /// and available for recording. Always returns `false` on non-Android platforms.
  Future<bool> isBluetoothScoAvailable() async {
    if (!Platform.isAndroid) return false;
    return BluetoothScoPlatform.instance.isBluetoothScoAvailable();
  }

  /// Activates Bluetooth SCO so the Android audio stack routes microphone
  /// input from the Bluetooth headset.
  ///
  /// Returns `true` if SCO was started successfully (a BT headset was found
  /// and activated). Returns `false` if no BT headset is available — in this
  /// case recording will fall back to the built-in microphone automatically.
  ///
  /// A short [stabilizationDelay] is applied after starting SCO to let the
  /// connection stabilise before the recorder is opened.
  Future<bool> startBluetoothSco({
    Duration stabilizationDelay = const Duration(milliseconds: 600),
  }) async {
    if (!Platform.isAndroid) return false;

    final started = await BluetoothScoPlatform.instance.startBluetoothSco();
    if (started) {
      // Give the SCO link time to establish before the recorder opens.
      await Future<void>.delayed(stabilizationDelay);
    }
    return started;
  }

  /// Deactivates Bluetooth SCO and restores the normal Android audio mode.
  /// Safe to call even when SCO was never started.
  Future<void> stopBluetoothSco() async {
    if (!Platform.isAndroid) return;
    return BluetoothScoPlatform.instance.stopBluetoothSco();
  }
}
