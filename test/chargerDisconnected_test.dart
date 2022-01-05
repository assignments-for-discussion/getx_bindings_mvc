import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final session = ChargerSession();
  Get.put(session);
  test(
    'intent to start charging with disconnected charger gives user hint',
    () {
      final dio = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onPost(
        'http://10.0.2.2:9090/device',
        (reqHandler) {
          reqHandler.reply(404, {'message': 'charger not connected'});
        },
        data: {
          'target': session.target.value,
          'request': 'startCharge',
          'connectorId': 1,
          'idTag': 'RFIDSAN',
        },
      );
      ChargeStarter(dio);

      session.chargeStartIntent.fire();
      return Future.delayed(Duration(milliseconds: 100), () {
        expect(session.userHint.value, contains('disconnected'));
      });
    },
  );
}
