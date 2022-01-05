import 'package:getx_bindings_mvc/home.dart';
import 'package:getx_bindings_mvc/statusView.dart';
import 'package:get/get.dart';

Home toHome(_) => Home();
StatusView toStatusScreen(_) => StatusView();

const navigationRoutes = {
  '/': toHome,
  '/status-screen': toStatusScreen,
};

dynamic theNavigator() {
  return GetMaterialApp(
    navigatorKey: Get.key,
    routes: navigationRoutes,
    navigatorObservers: [GetObserver()],
    initialRoute: '/',
  );
}
