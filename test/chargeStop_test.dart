import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final session = ChargerSession();
  Get.put(session);
  test('intent to stop charging triggers request to device', () {
    final dio = Dio(BaseOptions());
    final dioAdapter = DioAdapter(dio: dio);
    session.chargeStopIntent.reset();
    session.sessionId.value = 'session-for-stop';
    dioAdapter.onPost(
      'http://10.0.2.2:9090/device',
      (reqHandler) {
        reqHandler.reply(200, {'some': 'thing'});
      },
      data: {
        'target': session.target.value,
        'request': 'stopCharge',
        'sessionId': session.sessionId.value,
      },
    );
    ChargeStopper(dio);
    session.chargeStopIntent.fire();
    return Future.delayed(Duration(milliseconds: 30), () {
      expect(session.chargeStopIntent.isDone, equals(true));
    });
  });
}
