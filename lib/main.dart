import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargingView.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final ChargeControl c = Get.put(ChargeControl());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Status: ${c.status}"))),
      body: ChargingView(),
    );
  }
}
