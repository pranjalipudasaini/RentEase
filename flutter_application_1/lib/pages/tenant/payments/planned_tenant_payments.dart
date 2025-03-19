import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/payments/planned_tenant_payments_controller.dart';
import 'package:get/get.dart';

class PlannedTenantPayments extends GetView<PlannedTenantPaymentsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Text(
            "Payments Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
