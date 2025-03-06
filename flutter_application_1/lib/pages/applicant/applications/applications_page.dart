import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/applications/applications_controller.dart';
import 'package:flutter_application_1/pages/applicant/applications/view_application.dart';
import 'package:get/get.dart';

class ApplicationsPage extends GetView<TenantApplicationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Your Applications'),
      ),
      body: Obx(() {
        if (controller.applications.isEmpty) {
          return Center(child: Text('No applications found'));
        } else {
          return ListView.builder(
            itemCount: controller.applications.length,
            itemBuilder: (context, index) {
              var application = controller.applications[index];
              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color(0xFF062356), width: 2), // Outline color
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
                color: Colors.white, // Background color of the card
                child: ListTile(
                  title: Text(
                      "Application of ${application['fullName'] ?? 'N/A'}"), // Correct string interpolation
                  subtitle: Text(application['email'] ?? 'N/A'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to the View Application page
                    Get.to(() => ViewApplicationPage(application: application));
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
