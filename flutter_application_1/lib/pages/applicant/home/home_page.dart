import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/code/code.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/applicant/home/home_controller.dart';

class ApplicantHomePage extends GetView<ApplicantHomeController> {
  final String email;
  final String token;

  const ApplicantHomePage({required this.email, required this.token, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF062356),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.app_registration_rounded),
              title: Text('Code'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OTPVerificationPage(email: email, token: token)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to Settings Page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Handle logout functionality
              },
            ),
          ],
        ),
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
