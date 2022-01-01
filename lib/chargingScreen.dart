import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';
import 'package:getx_bindings_mvc/chargeProgressView.dart';
import 'package:getx_bindings_mvc/invoiceView.dart';

class ChargingScreen extends StatelessWidget {
  @override
  Widget build(context) {
    final ChargeControl c = Get.find();
    return Center(
      child: Column(children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => c.chargeStartIntent.fire(),
          child: const Text('Start'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => c.chargeStopPending.value = true,
          child: const Text('Stop'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          child: const Text('Other'),
          onPressed: () => Get.to(() => InvoiceView()),
        ),
        const SizedBox(height: 10),
        ChargeProgressView(),
      ]),
    );
  }
}
