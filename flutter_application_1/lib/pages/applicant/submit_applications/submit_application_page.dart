import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SubmitApplicationPage extends StatefulWidget {
  final Map<String, dynamic> property;

  SubmitApplicationPage({Key? key, required this.property}) : super(key: key);

  @override
  _SubmitApplicationPageState createState() => _SubmitApplicationPageState();
}

class _SubmitApplicationPageState extends State<SubmitApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  String employmentStatus = 'Employed';

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    final applicationData = {
      "fullName": fullNameController.text,
      "dob": dobController.text,
      "email": emailController.text,
      "contactNumber": contactController.text,
      "employmentStatus": employmentStatus,
      "propertyId": widget.property['_id'],
      "landlordEmail": widget.property['landlordEmail']
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/application/submit'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(applicationData),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Application submitted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        print("Response: ${response.body}"); // Debug response body
        Get.snackbar("Error", "Failed to submit application. ${response.body}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Application')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (value) => value!.isEmpty ? "Required" : null),
              TextFormField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: "Date of Birth"),
                  readOnly: true,
                  onTap: () => _selectDate(context)),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email ID"),
                  keyboardType: TextInputType.emailAddress),
              TextFormField(
                  controller: contactController,
                  decoration:
                      const InputDecoration(labelText: "Contact Number"),
                  keyboardType: TextInputType.phone),
              DropdownButtonFormField<String>(
                  value: employmentStatus,
                  items: ['Employed', 'Unemployed']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => employmentStatus = val!)),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: submitApplication, child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
