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
  test(
    'when the intent to start is done, progress is polled till stop',
    () async {
      final dio = Dio(BaseOptions());
      final dioAdapter = DioAdapter(dio: dio);
      session.sessionId.value = 'ongoing';
      session.chargeStartIntent.reset();
      session.chargeStopIntent.reset();
      dioAdapter.onGet('http://10.0.2.2:7902/api/transaction', (reqHandler) {
        reqHandler.reply(200, {
          'deliveredMin': 114,
          'deliveredWh': 115,
          'totalAmount': 116,
        });
      });
      ChargingPoller(dio);
      session.chargeStartIntent.done();
      await Future.delayed(Duration(milliseconds: 30), () {
        expect(session.deliveredMin.value, equals(114));
        expect(session.deliveredWh.value, equals(115));
        expect(session.totalAmountToPay.value, equals(116));
      });
      print('Setup for second call');
      dioAdapter.onGet('http://10.0.2.2:7902/api/transaction', (reqHandler) {
        reqHandler.reply(200, {
          'deliveredMin': 224,
          'deliveredWh': 225,
          'totalAmount': 226,
        });
      });
      await Future.delayed(Duration(seconds: 4), () {
        print('Checking second call');
        expect(session.deliveredMin.value, equals(224));
        expect(session.deliveredWh.value, equals(225));
        expect(session.totalAmountToPay.value, equals(226));
      });
      session.chargeStopIntent.done();
    },
  );
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
