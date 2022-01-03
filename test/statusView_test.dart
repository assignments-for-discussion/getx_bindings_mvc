import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/statusView.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/home.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final session = ChargerSession();
    session.status.value = 'Unknown';
    Get.put(session);

    await tester.pumpWidget(MaterialApp(home: StatusView()));

    // Verify that our counter starts at 0.
    expect(find.text('Unknown'), findsOneWidget);
    expect(find.text('haha'), findsNothing);
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(Get.find<ChargeStarter>(), TypeMatcher<ChargeStarter>());
  });
}
