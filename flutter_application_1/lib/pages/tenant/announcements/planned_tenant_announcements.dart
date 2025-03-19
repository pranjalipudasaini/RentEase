import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/announcements/planned_tenant_announcements_controller.dart';
import 'package:get/get.dart';

class PlannedTenantAnnouncements
    extends GetView<PlannedTenantAnnouncementsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Text(
            "Announcements Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
