import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/controller.dart';
import 'package:getx_bindings_mvc/chargeProgress.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
        // Use Obx(()=> to update Text() whenever count is changed.
        appBar: AppBar(title: Obx(() => Text("Status: ${c.status}"))),
        body: Center(
          child: Column(children: [
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => c.startCharging(), child: const Text("Start")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => c.stopCharging(), child: const Text("Stop")),
            const SizedBox(height: 10),
            ElevatedButton(
                child: const Text("Other"),
                onPressed: () => Get.to(() => Other())),
            const SizedBox(height: 10),
            ChargeProgress(),
          ]),
        ));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.status}")));
  }
}
