import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargingScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final ChargeControl c = Get.put(ChargeControl());

    return Scaffold(
      appBar: AppBar(title: Obx(() => Text('Status: ${c.status}'))),
      body: ChargingScreen(),
    );
  }
}
