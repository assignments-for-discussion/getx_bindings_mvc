import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getx_bindings_mvc/controller.dart';
import 'package:getx_bindings_mvc/main.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final control = Controller();
    control.status.value = "Unknown";
    Get.put(control);

    await tester.pumpWidget(MaterialApp(home: Other()));

    // Verify that our counter starts at 0.
    expect(find.text('Unknown'), findsOneWidget);
    expect(find.text('haha'), findsNothing);
  });
}
