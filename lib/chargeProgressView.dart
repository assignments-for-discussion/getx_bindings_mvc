import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';

class ChargeProgressView extends StatelessWidget {
  @override
  Widget build(context) {
    final ChargerSession c = Get.find();
    return Column(
      children: [
        Obx(() => Text('Delivered Energy (Wh): ' + c.deliveredWh.toString())),
        Obx(() => Text('Duration (mins): ' + c.deliveredMin.toString())),
        Obx(() => Text('Estimate (Rs): ' + c.totalAmountToPay.toString())),
        Obx(() => Text(c.userHint.toString())),
      ],
    );
  }
}
