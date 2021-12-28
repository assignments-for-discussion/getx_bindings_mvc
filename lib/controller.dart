import 'package:get/get.dart';
import 'package:dio/dio.dart';

dynamic post(url, body) async {
  try {
    var response = await Dio().post(url, data: body);
    return response.data;
  } catch (e) {
    print("Dio POST error: $e");
    return e;
  }
}

dynamic get(url, query) async {
  try {
    var response = await Dio().get(url, queryParameters: query);
    return response.data;
  } catch (e) {
    print("Dio GET error: $e");
    return e;
  }
}

const deviceUrl = 'http://10.0.2.2:9090/device';
const progressUrl = 'http://10.0.2.2:7902/api/transaction';

class Controller extends GetxController {
  var status = 'Available'.obs;
  var lastSessionId = ''.obs;
  var deliveredMin = 0.obs;
  var deliveredWh = 0.obs;
  var totalAmountToPay = 0.obs;
  var target = '/numotry/7RUFAT/cpsud001'.obs;

  void startCharging() async {
    var started = await post(deviceUrl, {
      "target": target.value,
      "request": "startCharge",
      "connectorId": 1,
      "idTag": "RFIDSAN",
    });
    print("Started charging: $started");
    lastSessionId.value = started["sessionId"];
    status.value = 'Busy';
    pollChargingProgress();
  }

  void pollChargingProgress() async {
    var progress = await get(progressUrl, {
      "numotype": "numotry",
      "sessionId": lastSessionId.value,
    });
    print("Updating progress for ${lastSessionId.value}: $progress");
    deliveredMin.value = progress["deliveredMin"].toInt();
    deliveredWh.value = progress["deliveredWh"].toInt();
    totalAmountToPay.value = progress["totalAmount"].toInt();
    if (status.value == 'Busy') {
      Future.delayed(const Duration(seconds: 3), pollChargingProgress);
    }
  }

  void stopCharging() async {
    var stopped = await post(deviceUrl, {
      "target": target.value,
      "request": "stopCharge",
      "sessionId": lastSessionId.value,
    });
    print("Stopped charging: $stopped");
    status.value = 'Available';
  }
}
