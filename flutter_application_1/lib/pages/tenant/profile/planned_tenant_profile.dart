import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/profile/planned_tenant_profile_controller.dart';
import 'package:get/get.dart';

class PlannedTenantProfile extends GetView<PlannedTenantProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Text(
            "Profile Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
