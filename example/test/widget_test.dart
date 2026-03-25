// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bluetooth_sco_example/main.dart';

void main() {
  testWidgets('Verify SCO UI elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that SCO status is displayed.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data!.startsWith('SCO Status:'),
      ),
      findsOneWidget,
    );

    // Verify that SCO control buttons are present.
    expect(find.text('Check SCO Availability'), findsOneWidget);
    expect(find.text('Start Bluetooth SCO'), findsOneWidget);
    expect(find.text('Stop Bluetooth SCO'), findsOneWidget);
  });
}
