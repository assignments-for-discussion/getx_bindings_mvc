import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'intent.dart';

// TODO: split this to have the intents in SessionIntents
class ChargerSession extends GetxController {
  var status = 'Available'.obs;
  var sessionId = ''.obs;
  var deliveredMin = 0.obs;
  var deliveredWh = 0.obs;
  var totalAmountToPay = 0.obs;
  var target = '/numotry/7RUFAT/cpsud001'.obs;
  var chargeStartIntent = Intent();
  var chargeStopIntent = Intent();
  var userHint = ''.obs;
}

// TODO: Move these to a separate file along with the Controllers below
const deviceUrl = 'http://10.0.2.2:9090/device';
const progressUrl = 'http://10.0.2.2:7902/api/transaction';

class ChargeStarter extends GetxController {
  ChargerSession session = Get.find();
  Dio dio;
  ChargeStarter(this.dio) {
    session.chargeStartIntent.onFire((p0) async {
      await startCharging();
      session.chargeStartIntent.done();
    });
  }
  Future<void> startCharging() async {
    session.userHint.value = 'Attempting to start...';
    var started = await dio.post('http://10.0.2.2:9090/device', data: {
      'target': session.target.value,
      'request': 'startCharge',
      'connectorId': 1,
      'idTag': 'RFIDSAN',
    });
    session.sessionId.value = started.data['sessionId'];
    session.userHint.value = 'Charging session: ${session.sessionId.value}';
    session.status.value = 'Busy';
  }
}

class ChargingPoller extends GetxController {
  ChargerSession session = Get.find();
  Dio dio;
  ChargingPoller(this.dio) {
    session.chargeStartIntent.onDone((p0) {
      pollChargingProgress();
    });
  }
  void pollChargingProgress() async {
    try {
      final response = await dio.get(progressUrl, queryParameters: {
        'numotype': 'numotry',
        'sessionId': session.sessionId.value,
      });
      final progress = response.data;
      print('Updating progress for ${session.sessionId.value}: $progress');
      session.deliveredMin.value = progress['deliveredMin'].toInt();
      session.deliveredWh.value = progress['deliveredWh'].toInt();
      session.totalAmountToPay.value = progress['totalAmount'].toInt();
    } catch (e) {
      print('GET error: $e');
    }
    if (session.chargeStopIntent.isPending) {
      Future.delayed(const Duration(seconds: 3), pollChargingProgress);
    }
  }
}

class ChargeStopper extends GetxController {
  ChargerSession session = Get.find();
  Dio dio;
  ChargeStopper(this.dio) {
    session.chargeStopIntent.onFire((p0) async {
      await stopCharging();
      session.chargeStopIntent.done();
    });
  }

  Future<void> stopCharging() async {
    session.userHint.value = 'Stopping the session...';
    await dio.post(deviceUrl, data: {
      'target': session.target.value,
      'request': 'stopCharge',
      'sessionId': session.sessionId.value,
    });
    session.userHint.value = 'Stopped charging ${session.sessionId.value}';
    session.status.value = 'Available';
  }
}
