import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/requests/planned_tenant_requests_controller.dart';
import 'package:get/get.dart';

class PlannedTenantRequests extends GetView<PlannedTenantRequestsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Text(
            "Requests Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
