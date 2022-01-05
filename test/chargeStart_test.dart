import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final session = ChargerSession();
  Get.put(session);
  test('intent to start charging will request the charger', () async {
    final dio = Dio(BaseOptions());
    ChargeStarter(dio);
    final dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onPost(
      'http://10.0.2.2:9090/device',
      (reqHandler) {
        reqHandler.reply(200, {'sessionId': 'yes:'});
      },
      data: {
        'target': session.target.value,
        'request': 'startCharge',
        'connectorId': 1,
        'idTag': 'RFIDSAN',
      },
    );
    session.chargeStartIntent.reset();
    session.chargeStartIntent.fire();
    return Future.delayed(Duration(milliseconds: 30), () {
      expect(session.sessionId.value, equals('yes:'));
    });
  });
}
