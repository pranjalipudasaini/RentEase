import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LandlordViewApplicationPage extends StatefulWidget {
  final Map application;

  LandlordViewApplicationPage({required this.application});

  @override
  _LandlordViewApplicationPageState createState() =>
      _LandlordViewApplicationPageState();
}

class _LandlordViewApplicationPageState
    extends State<LandlordViewApplicationPage> {
  String selectedStatus = 'Pending';

  Future<void> updateApplicationStatus(String status) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/application/updateStatus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'applicationId': widget.application['_id'], 'status': status}),
    );

    if (response.statusCode == 200) {
      setState(() {
        selectedStatus = status;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Status updated successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.application['status'] ?? 'Pending';
  }

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
            Text('Full Name: ${widget.application['fullName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${widget.application['email'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Contact Number: ${widget.application['contactNumber'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Employment Status: ${widget.application['employmentStatus'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Landlord Name: ${widget.application['landlordName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Tenancy Duration: ${widget.application['tenancyDuration'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
                'Reason for Leaving: ${widget.application['reasonLeaving'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedStatus,
              items: ['Pending', 'Approved', 'Declined'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  updateApplicationStatus(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
