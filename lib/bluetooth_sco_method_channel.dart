import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_sco_platform_interface.dart';

/// An implementation of [BluetoothScoPlatform] that uses method channels.
class MethodChannelBluetoothSco extends BluetoothScoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_sco');

  @override
  Future<bool> isBluetoothScoAvailable() async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'isBluetoothScoAvailable',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> startBluetoothSco() async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'startBluetoothSco',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> stopBluetoothSco() async {
    try {
      await methodChannel.invokeMethod<void>(
        'stopBluetoothSco',
      );
    } catch (e) {
      // Ignore errors - worst case the system will clean up on its own
    }
  }
}
