import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/controller.dart';

class ChargeProgress extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller c = Get.find();
    return Column(
      children: [
        Obx(() => Text("Delivered Energy (Wh): " + c.deliveredWh.toString())),
        Obx(() => Text("Duration (mins): " + c.deliveredMin.toString())),
        Obx(() => Text("Estimate (Rs): " + c.totalAmountToPay.toString())),
      ],
    );
  }
}
