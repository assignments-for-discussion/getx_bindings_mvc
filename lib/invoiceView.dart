import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_bindings_mvc/chargeControl.dart';

class InvoiceView extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final ChargeControl c = Get.find();

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.status}")));
  }
}
