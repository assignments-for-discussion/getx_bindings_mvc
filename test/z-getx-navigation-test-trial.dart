import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Test of Get.toOffNamed', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      navigatorKey: Get.key,
      routes: {
        '/': (_) {
          print('in / now');
          return ElevatedButton(
            child: Text('second'),
            onPressed: () {
              Get.toNamed('/second');
            },
          );
        },
        '/second': (_) {
          print('in /second now');
          return ElevatedButton(
            child: Text('third'),
            onPressed: () {
              Get.offNamed('/third');
            },
          );
        },
        '/third': (_) => ElevatedButton(
              child: Text('back'),
              onPressed: () {
                Get.back();
              },
            ),
      },
      navigatorObservers: [GetObserver()],
      initialRoute: '/',
    ));

    await tester.tap(find.text('second'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    print('path after second: ${Get.currentRoute}');

    await tester.tap(find.text('third'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(Get.currentRoute, '/');
  });
}
