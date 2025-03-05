import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/auth_service.dart';
import 'package:flutter_application_1/pages/applicant/tenant_dashboard.dart';
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
  late final TenantAuthService authService;
  late final RxString token;

  @override
  void initState() {
    super.initState();
    authService = Get.find<TenantAuthService>(); // Get AuthService instance
    token = authService.token; // Assign the token from AuthService
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController landlordController = TextEditingController();
  final TextEditingController tenancyDurationController =
      TextEditingController();
  final TextEditingController reasonLeavingController = TextEditingController();

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
      "currentAddress": addressController.text,
      "employmentStatus": employmentStatus,
      "employerName": employerController.text,
      "jobTitle": jobTitleController.text,
      "income": incomeController.text,
      "landlordName": landlordController.text,
      "tenancyDuration": tenancyDurationController.text,
      "reasonLeaving": reasonLeavingController.text,
      "propertyId": widget.property['_id'],
      "landlordEmail": widget.property['landlordEmail'],
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/application/submit'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token.value}", // Add the token here
        },
        body: jsonEncode(applicationData),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Application submitted successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Navigate to Applicant Dashboard after submission
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => TenantDashboard(token: token.value),
          ),
        );
      } else {
        Get.snackbar("Error", "Failed to submit application.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: const Text('Submit Application'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildSectionTitle("Personal Information"),
              buildTextField(fullNameController, "Full Name", required: true),
              buildDatePickerField(dobController, "Date of Birth"),
              buildTextField(emailController, "Email ID",
                  required: true, keyboardType: TextInputType.emailAddress),
              buildTextField(contactController, "Contact Number",
                  required: true, keyboardType: TextInputType.phone),
              buildTextField(addressController, "Current Address"),
              buildSectionTitle("Employment and Income Details"),
              buildDropdownField(
                  "Employment Status", ['Employed', 'Unemployed']),
              buildTextField(employerController, "Employer Name"),
              buildTextField(jobTitleController, "Job Title"),
              buildTextField(incomeController, "Annual/Monthly Income",
                  required: true, keyboardType: TextInputType.number),
              buildSectionTitle("Rental History"),
              buildTextField(
                  landlordController, "Previous/Current Landlord Name"),
              buildTextField(tenancyDurationController, "Duration of Tenancy"),
              buildTextField(reasonLeavingController, "Reason for Leaving"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF062356), // Button color #062356
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {bool required = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator:
            required ? (value) => value!.isEmpty ? "Required" : null : null,
      ),
    );
  }

  Widget buildDatePickerField(
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: DropdownButtonFormField<String>(
        value: employmentStatus,
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => setState(() => employmentStatus = val!),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
