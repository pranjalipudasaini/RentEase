import 'package:flutter/material.dart';

class ViewApplicationPage extends StatelessWidget {
  final Map application;

  // Constructor to accept application data
  ViewApplicationPage({required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Application Details'),
        backgroundColor: Color(0xFF062356),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: ${application['fullName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${application['email'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Contact Number: ${application['contactNumber'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Employment Status: ${application['employmentStatus'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Landlord Name: ${application['landlordName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Tenancy Duration: ${application['tenancyDuration'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Reason for Leaving: ${application['reasonLeaving'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status: ${application['status'] ?? 'Pending'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
