import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargeProgressView.dart';

class ChargingScreen extends StatelessWidget {
  @override
  Widget build(context) {
    final ChargerSession session = Get.find();
    return Center(
      child: Column(children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => session.chargeStartIntent.fire(),
          child: const Text('Start'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => session.chargeStopIntent.fire(),
          child: const Text('Stop'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          child: const Text('Status'),
          onPressed: () => Get.toNamed('/status-screen'),
        ),
        const SizedBox(height: 10),
        ChargeProgressView(),
      ]),
    );
  }
}
