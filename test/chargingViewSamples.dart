import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargingScreen.dart';
import 'package:getx_bindings_mvc/statusView.dart';

void main() {
  Get.put(ChargerSession());
  runApp(GetMaterialApp(
    navigatorKey: Get.key,
    routes: {
      '/': (_) => ChargingViewSamples(),
      '/statusView': (_) {
        print('going to status');
        return StatusView();
      },
    },
    navigatorObservers: [GetObserver()],
    initialRoute: '/',
  ));
}

class ChargingViewSamples extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charging Samples')),
      body: Column(children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: waitingToStart,
          child: const Text('Waiting to start'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: startedCharging,
          child: const Text('Started Charging'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: longErrorMessage,
          child: const Text('Long error message'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Get.toNamed('/statusView');
          },
          child: const Text('Show Status'),
        ),
      ]),
    );
  }

  void setupController(deliveredMin, deliveredWh, userHint) {
    Get.delete<ChargerSession>();
    final ChargerSession c = ChargerSession();
    c.deliveredMin.value = deliveredMin;
    c.deliveredWh.value = deliveredWh;
    c.userHint.value = userHint;
    Get.put(c);
  }

  void waitingToStart() {
    setupController(0, 0, 'Waiting to start');
    Get.to(() => Scaffold(body: ChargingScreen()));
  }

  void startedCharging() {
    setupController(33, 888, 'Charging');
    Get.to(() => Scaffold(body: ChargingScreen()));
  }

  void longErrorMessage() {
    setupController(
      0,
      0,
      "Error while fetching progress: Looks like you don't have an internet connection. Please check if your phone is in airplane mode.",
    );
    Get.to(() => Scaffold(body: ChargingScreen()));
  }
}
