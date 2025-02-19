import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/applicant/home/home_controller.dart';

class ApplicantHomePage extends GetView<ApplicantHomeController> {
  final String email;

  const ApplicantHomePage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Add drawer navigation if needed
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.insert_drive_file,
                      size: 100, color: Colors.grey),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: Container(
                      width: 80,
                      height: 4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "You are not connected to any properties yet. To get started, you can apply for a property by submitting your application or connect to an existing one.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildLink("Browse Properties"),
              _buildLink("View Application Status"),
              _buildLink("Connect to an existing Property"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
