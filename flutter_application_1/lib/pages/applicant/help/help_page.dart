import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/help/help_controller.dart';
import 'package:get/get.dart';

class HelpPage extends GetView<HelpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Help and Support",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Find answers to common questions and get help with your account.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              "Frequently Asked Questions:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildHelpTile("Account and Profile"),
            _buildHelpTile("Payments"),
            _buildHelpTile("Application Process"),
            _buildHelpTile("Maintenance Requests"),
            const SizedBox(height: 30),
            const Text(
              "For Contact Support:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSupportInfo("Email: rentease77@gmail.com"),
            _buildSupportInfo("Contact number: +(977) 9847346364"),
            _buildSupportInfo("Support hours: 9AM – 5PM every day"),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpTile(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        onTap: () {},
      ),
    );
  }

  Widget _buildSupportInfo(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(text,
          style: const TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
