import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_sco/bluetooth_sco.dart';
import 'package:bluetooth_sco/bluetooth_sco_platform_interface.dart';
import 'package:bluetooth_sco/bluetooth_sco_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBluetoothScoPlatform
    with MockPlatformInterfaceMixin
    implements BluetoothScoPlatform {
  @override
  Future<bool> isBluetoothScoAvailable() => Future.value(true);

  @override
  Future<bool> startBluetoothSco() => Future.value(true);

  @override
  Future<void> stopBluetoothSco() => Future.value();
}

void main() {
  final BluetoothScoPlatform initialPlatform = BluetoothScoPlatform.instance;

  test('$MethodChannelBluetoothSco is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBluetoothSco>());
  });

  test('isBluetoothScoAvailable', () async {
    BluetoothSco bluetoothScoPlugin = BluetoothSco();
    MockBluetoothScoPlatform fakePlatform = MockBluetoothScoPlatform();
    BluetoothScoPlatform.instance = fakePlatform;

    expect(await bluetoothScoPlugin.isBluetoothScoAvailable(), true);
  });
}
