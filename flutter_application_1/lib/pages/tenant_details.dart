import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/landlord/tenants/tenant_controller.dart';
import 'rent_details.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TenantDetailsPage extends StatefulWidget {
  final String token;
  final bool isFromSignUp;
  final Map<String, dynamic>? tenant;

  const TenantDetailsPage({
    Key? key,
    required this.token,
    this.isFromSignUp = false,
    this.tenant,
  }) : super(key: key);

  @override
  _TenantDetailsPageState createState() => _TenantDetailsPageState();
}

class _TenantDetailsPageState extends State<TenantDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _tenantNameController = TextEditingController();
  final _tenantEmailController = TextEditingController();
  final _tenantContactController = TextEditingController();
  final _leaseStartDateController = TextEditingController();
  final _leaseEndDateController = TextEditingController();
  final _rentAmountController = TextEditingController();

  String? _selectedProperty;
  List<dynamic> _properties = [];

  @override
  void initState() {
    super.initState();
    _fetchProperties();
    if (widget.tenant != null) {
      _tenantNameController.text = widget.tenant!['tenantName'] ?? '';
      _tenantEmailController.text = widget.tenant!['tenantEmail'] ?? '';
      _tenantContactController.text =
          widget.tenant!['tenantContactNumber'] ?? '';
      _leaseStartDateController.text = widget.tenant!['leaseStartDate'] ?? '';
      _leaseEndDateController.text = widget.tenant!['leaseEndDate'] ?? '';
      _rentAmountController.text =
          widget.tenant!['rentAmount']?.toString() ?? '';
    }
  }

  void dispose() {
    _tenantNameController.dispose();
    _tenantEmailController.dispose();
    _tenantContactController.dispose();
    _leaseStartDateController.dispose();
    _leaseEndDateController.dispose();
    _rentAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _saveTenantDetails() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Remove focus before submitting

      final tenantDetails = {
        "tenantName": _tenantNameController.text,
        "tenantEmail": _tenantEmailController.text,
        "tenantContactNumber": _tenantContactController.text,
        "leaseStartDate": _leaseStartDateController.text,
        "leaseEndDate": _leaseEndDateController.text,
        "rentAmount": double.tryParse(_rentAmountController.text) ?? 0,
        "propertyId": _selectedProperty,
      };

      try {
        final uri = widget.tenant == null
            ? Uri.parse('http://localhost:3000/tenant/saveTenant')
            : Uri.parse(
                'http://localhost:3000/tenant/updateTenant/${widget.tenant!['_id']}');

        final response = widget.tenant == null
            ? await http.post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                },
                body: jsonEncode(tenantDetails),
              )
            : await http.put(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                },
                body: jsonEncode(tenantDetails),
              );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.find<TenantController>().fetchTenants();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tenant saved successfully!')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LandlordDashboard(token: widget.token),
            ),
            (route) => false,
          );
        } else {
          print('Failed to save tenant: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save tenant: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
    }
  }

  Future<void> _fetchProperties() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/property/getProperty'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true &&
            responseData.containsKey('success')) {
          setState(() {
            _properties = responseData['success']; // Extracting the actual list
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unexpected response format')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch properties: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching properties')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Tenant Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Please enter your tenant details below and click submit:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _tenantNameController,
                label: 'Enter Tenant Name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tenantEmailController,
                label: 'Enter Tenant Email',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tenantContactController,
                label: 'Enter Tenant Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildDateField(
                controller: _leaseStartDateController,
                label: 'Enter Lease Start Date (MM/DD/YYYY)',
              ),
              const SizedBox(height: 16),
              _buildDateField(
                controller: _leaseEndDateController,
                label: 'Enter Lease End Date (MM/DD/YYYY)',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _rentAmountController,
                label: 'Enter Rent Amount (NRS)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedProperty,
                decoration: InputDecoration(
                  labelText: 'Select Property',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: _properties.map((property) {
                  return DropdownMenuItem<String>(
                    value: property['_id'],
                    child: Text(property['propertyName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProperty = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a property';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTenantDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Tenant',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.isFromSignUp)
                TextButton(
                  onPressed: () {
                    // Navigate to RentDetailsPage if accessed during sign-up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentDetailsPage(
                          token: widget.token,
                          isFromSignUp: true,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LandlordDashboard(token: widget.token),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill out this field';
        }
        return null;
      },
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.teal),
          onPressed: () => _selectDate(controller),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }
}
