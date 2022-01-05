import 'package:getx_bindings_mvc/chargingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:get/get.dart';

void main() {
  final session = ChargerSession();
  Get.put(session);
  testWidgets(
    'Buttons trigger intents',
    (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(
        navigatorKey: Get.key,
        routes: {
          '/': (_) => ChargingScreen(),
          '/status-screen': (_) {
            print('going to status');
            return Text('status-dummy');
          },
        },
        navigatorObservers: [GetObserver()],
        initialRoute: '/',
      ));
      await tester.tap(find.text('Start'));
      expect(session.chargeStartIntent.isPending, equals(true));
      await tester.tap(find.text('Stop'));
      expect(session.chargeStopIntent.isPending, equals(true));
      print('tapping status...');
      await tester.tap(find.text('Status'));
      print('current route is ${Get.currentRoute}');
      expect(Get.currentRoute, equals('/status-screen'));
    },
  );
}
