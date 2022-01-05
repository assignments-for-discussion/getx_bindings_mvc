import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  final session = ChargerSession();
  Get.put(session);
  test(
    'it gives user hint while polling when there is no progress yet',
    () async {
      final dio = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onGet('http://10.0.2.2:7902/api/transaction', (reqHandler) {
        reqHandler.reply(404, {'message': 'no transaction'});
      });

      ChargingPoller(dio);
      session.chargeStartIntent.done();
      await Future.delayed(Duration(milliseconds: 30), () {
        expect(session.userHint.value, contains('No progress'));
      });
    },
  );
}
