import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/invoiceView.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/home.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final control = ChargeControl();
    control.status.value = 'Unknown';
    Get.put(control);

    await tester.pumpWidget(MaterialApp(home: InvoiceView()));

    // Verify that our counter starts at 0.
    expect(find.text('Unknown'), findsOneWidget);
    expect(find.text('haha'), findsNothing);
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));
    expect(Get.find<ChargeControl>(), TypeMatcher<ChargeControl>());
  });
}
