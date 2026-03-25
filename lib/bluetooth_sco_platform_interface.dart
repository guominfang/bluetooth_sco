import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_sco_method_channel.dart';

abstract class BluetoothScoPlatform extends PlatformInterface {
  /// Constructs a BluetoothScoPlatform.
  BluetoothScoPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothScoPlatform _instance = MethodChannelBluetoothSco();

  /// The default instance of [BluetoothScoPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothSco].
  static BluetoothScoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothScoPlatform] when
  /// they register themselves.
  static set instance(BluetoothScoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns `true` if a Bluetooth SCO/headset device is currently connected
  /// and available for recording. Always returns `false` on non-Android platforms.
  Future<bool> isBluetoothScoAvailable() {
    throw UnimplementedError('isBluetoothScoAvailable() has not been implemented.');
  }

  /// Activates Bluetooth SCO so the Android audio stack routes microphone
  /// input from the Bluetooth headset.
  ///
  /// Returns `true` if SCO was started successfully (a BT headset was found
  /// and activated). Returns `false` if no BT headset is available.
  Future<bool> startBluetoothSco() {
    throw UnimplementedError('startBluetoothSco() has not been implemented.');
  }

  /// Deactivates Bluetooth SCO and restores the normal Android audio mode.
  /// Safe to call even when SCO was never started.
  Future<void> stopBluetoothSco() {
    throw UnimplementedError('stopBluetoothSco() has not been implemented.');
  }
}
