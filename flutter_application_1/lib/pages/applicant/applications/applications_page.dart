import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/applications/applications_controller.dart';
import 'package:get/get.dart';

class ApplicationsPage extends GetView<ApplicationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        child: Center(
          child: Text(
            "Applications Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
