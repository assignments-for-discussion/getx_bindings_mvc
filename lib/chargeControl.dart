import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'intent.dart';

dynamic post(String url, Map<String, dynamic> body) async {
  try {
    var response = await Dio().post(url, data: body);
    return response.data;
  } catch (e) {
    print('Dio POST error: $e');
    return e;
  }
}

const deviceUrl = 'http://10.0.2.2:9090/device';
const progressUrl = 'http://10.0.2.2:7902/api/transaction';

class ChargeControl extends GetxController {
  var status = 'Available'.obs;
  var lastSessionId = ''.obs;
  var deliveredMin = 0.obs;
  var deliveredWh = 0.obs;
  var totalAmountToPay = 0.obs;
  var target = '/numotry/7RUFAT/cpsud001'.obs;
  var chargeStartIntent = Intent();
  var chargeStopPending = false.obs;
  var userHint = ''.obs;

  ChargeControl() {
    chargeStartIntent.onFire((p0) async {
      await startCharging();
      chargeStartIntent.done();
    });
    chargeStopPending.listen((p0) async {
      if (chargeStopPending.isTrue) {
        await stopCharging();
        chargeStopPending.value = false;
      }
    });
    userHint.value = 'Waiting to start...';
  }

  Future<void> startCharging() async {
    userHint.value = 'Attempting to start...';
    var started = await post(deviceUrl, {
      'target': target.value,
      'request': 'startCharge',
      'connectorId': 1,
      'idTag': 'RFIDSAN',
    });
    lastSessionId.value = started['sessionId'];
    userHint.value = 'Charging session: ${lastSessionId.value}';
    status.value = 'Busy';
    pollChargingProgress();
  }

  void pollChargingProgress() async {
    try {
      final response = await Dio().get(progressUrl, queryParameters: {
        'numotype': 'numotry',
        'sessionId': lastSessionId.value,
      });
      final progress = response.data;
      print('Updating progress for ${lastSessionId.value}: $progress');
      deliveredMin.value = progress['deliveredMin'].toInt();
      deliveredWh.value = progress['deliveredWh'].toInt();
      totalAmountToPay.value = progress['totalAmount'].toInt();
    } catch (e) {
      print('GET error: $e');
    }
    if (status.value == 'Busy') {
      Future.delayed(const Duration(seconds: 3), pollChargingProgress);
    }
  }

  Future<void> stopCharging() async {
    userHint.value = 'Stopping the session...';
    await post(deviceUrl, {
      'target': target.value,
      'request': 'stopCharge',
      'sessionId': lastSessionId.value,
    });
    userHint.value = 'Stopped charging ${lastSessionId.value}';
    status.value = 'Available';
  }
}
