import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bluetooth_sco/bluetooth_sco_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBluetoothSco platform = MethodChannelBluetoothSco();
  const MethodChannel channel = MethodChannel('bluetooth_sco');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'isBluetoothScoAvailable':
              return true;
            case 'startBluetoothSco':
              return true;
            case 'stopBluetoothSco':
              return null;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isBluetoothScoAvailable', () async {
    expect(await platform.isBluetoothScoAvailable(), true);
  });

  test('startBluetoothSco', () async {
    expect(await platform.startBluetoothSco(), true);
  });

  test('stopBluetoothSco', () async {
    await platform.stopBluetoothSco();
  });
}
