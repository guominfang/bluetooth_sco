// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bluetooth_sco/bluetooth_sco.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isBluetoothScoAvailable test', (WidgetTester tester) async {
    final BluetoothSco plugin = BluetoothSco();
    final bool available = await plugin.isBluetoothScoAvailable();
    // Should return a boolean value
    expect(available, isA<bool>());
  });

  testWidgets('startBluetoothSco test', (WidgetTester tester) async {
    final BluetoothSco plugin = BluetoothSco();
    final bool started = await plugin.startBluetoothSco();
    // Should return a boolean value
    expect(started, isA<bool>());
  });

  testWidgets('stopBluetoothSco test', (WidgetTester tester) async {
    final BluetoothSco plugin = BluetoothSco();
    // Should complete without error
    await plugin.stopBluetoothSco();
  });
}
