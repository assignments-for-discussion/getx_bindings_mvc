import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargingScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final ChargerSession session = Get.put(ChargerSession());

    // TODO: Shift these to a separate bindings file
    final dio = Dio();
    Get.put(ChargeStarter(dio));
    Get.put(ChargingPoller(dio));
    Get.put(ChargeStopper(dio));

    return Scaffold(
      appBar: AppBar(title: Obx(() => Text('Status: ${session.status}'))),
      body: ChargingScreen(),
    );
  }
}
