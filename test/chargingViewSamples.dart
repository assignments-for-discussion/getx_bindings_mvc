import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargingView.dart';

void main() => runApp(GetMaterialApp(home: ChargingViewSamples()));

class ChargingViewSamples extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Charging Samples")),
      body: Column(children: [
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: waitingToStart, child: const Text("Waiting to start")),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: startedCharging, child: const Text("Started Charging")),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: longErrorMessage,
            child: const Text("Long error message")),
      ]),
    );
  }

  void waitingToStart() {
    Get.delete<ChargeControl>();
    final ChargeControl c = ChargeControl();
    c.userHint.value = "Waiting to start";
    Get.put(c);
    Get.to(() => Scaffold(body: ChargingView()));
  }

  void startedCharging() {
    Get.delete<ChargeControl>();
    final ChargeControl c = ChargeControl();
    c.deliveredMin.value = 800;
    c.deliveredWh.value = 33;
    c.userHint.value = "Charging";
    Get.put(c);
    Get.to(() => Scaffold(body: ChargingView()));
  }

  void longErrorMessage() {
    Get.delete<ChargeControl>();
    final ChargeControl c = ChargeControl();
    c.userHint.value =
        "Error while fetching progress: Looks like you don't have an internet connection. Please check if your phone is in airplane mode.";
    Get.put(c);
    Get.to(() => Scaffold(body: ChargingView()));
  }
}
