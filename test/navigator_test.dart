import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/home.dart';
import 'package:getx_bindings_mvc/navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/statusView.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ChargerSession());
  test('brings up the app', () {
    expect(theNavigator(), TypeMatcher<GetMaterialApp>());
  });
  test('navigates to home', () {
    expect(navigationRoutes['/']!(0), TypeMatcher<Home>());
  });
  test('navigates to status-screen', () {
    expect(navigationRoutes['/status-screen']!(0), TypeMatcher<StatusView>());
  });
}
