import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:intl/intl.dart';

class RentDetailsPage extends StatefulWidget {
  final String token;
  final bool isFromSignUp;
  final Map<String, dynamic>? rent;

  const RentDetailsPage({
    Key? key,
    required this.token,
    this.isFromSignUp = false,
    this.rent,
  }) : super(key: key);

  @override
  _RentDetailsPageState createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _dueDateController = TextEditingController();
  final _otherChargesController = TextEditingController();
  final _lateFeeDaysController = TextEditingController();
  final _lateFeeAmountController = TextEditingController();
  final _rentAmountController = TextEditingController();
  final _leaseStartDateController = TextEditingController();
  final _leaseEndDateController = TextEditingController();

  String _selectedRecurringDay = '1st';
  String? _selectedTenant;
  List<dynamic> _tenants = [];

  @override
  void dispose() {
    _dueDateController.dispose();
    _otherChargesController.dispose();
    _lateFeeDaysController.dispose();
    _lateFeeAmountController.dispose();
    _rentAmountController.dispose();
    _leaseStartDateController.dispose();
    _leaseEndDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _fetchTenants() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/tenant/getTenant'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true &&
            responseData.containsKey('success')) {
          setState(() {
            _tenants = responseData[
                'success']; // Fix: Use 'success' instead of 'tenants'
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Unexpected response format: ${response.body}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch tenants: ${response.body}')),
        );
      }
    } catch (error) {
      print("Error fetching tenants: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching tenants')),
      );
    }
  }

  bool _isSubmitting = false;

  Future<void> _saveRentDetails() async {
    if (_formKey.currentState!.validate()) {
      if (_isSubmitting) return; // Prevent duplicate submissions
      setState(() {
        _isSubmitting = true;
      });

      final rentDetails = {
        "dueDate": _dueDateController.text,
        "otherCharges": double.tryParse(_otherChargesController.text) ?? 0,
        "lateFeeCharges": {
          "days": int.tryParse(_lateFeeDaysController.text) ?? 0,
          "amount": double.tryParse(_lateFeeAmountController.text) ?? 0,
        },
        "recurringDay": _selectedRecurringDay,
        "tenantId": _selectedTenant,
      };

      try {
        final String apiUrl;
        final bool isEditing =
            widget.rent != null && widget.rent!.containsKey('_id');

        if (isEditing) {
          final String? rentId = widget.rent?['_id'];
          if (isEditing && rentId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: Rent ID is missing')),
            );
            return;
          }

          apiUrl = 'http://localhost:3000/rent/updateRent/$rentId';

          final response = await http.put(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${widget.token}",
            },
            body: jsonEncode(rentDetails),
          );

          if (response.statusCode == 200) {
            RentController rentController = Get.find();
            rentController.updateRent(rentId!, rentDetails);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Rent details updated successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to update rent: ${response.body}')),
            );
          }
        } else {
          apiUrl = 'http://localhost:3000/rent/saveRent';

          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${widget.token}",
            },
            body: jsonEncode(rentDetails),
          );

          if (response.statusCode == 201) {
            RentController rentController = Get.find();
            rentController.addRent(rentDetails);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rent details saved successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save rent: ${response.body}')),
            );
          }
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LandlordDashboard(token: widget.token),
          ),
          (route) => false,
        );
      } catch (error) {
        print("Error saving rent: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $error')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTenants(); // Fetch tenants when page loads
    _prefillRentDetails(); // Prefill if editing
  }

  void _prefillRentDetails() {
    if (widget.rent != null) {
      print("Prefilling rent details: ${widget.rent}");
      setState(() {
        _rentAmountController.text =
            widget.rent?['rentAmount']?.toString() ?? '';
        _leaseStartDateController.text = widget.rent?['leaseStartDate'] ?? '';
        _leaseEndDateController.text = widget.rent?['leaseEndDate'] ?? '';
        _dueDateController.text = widget.rent?['dueDate'] ?? '';
        _otherChargesController.text =
            widget.rent?['otherCharges']?.toString() ?? '';
        _lateFeeDaysController.text =
            widget.rent?['lateFeeCharges']?['days']?.toString() ?? '';
        _lateFeeAmountController.text =
            widget.rent?['lateFeeCharges']?['amount']?.toString() ?? '';
        _selectedRecurringDay = widget.rent?['recurringDay'] ?? '1st';
        _selectedTenant = widget.rent?['tenantId'];
      });
    } else {
      print("No rent details to prefill.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Rent Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: HexColor("062356"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Please enter your rent details below and click submit:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(
                  labelText: 'Select Due Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDueDate,
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a due date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _otherChargesController,
                decoration:
                    const InputDecoration(labelText: 'Enter Other Charges'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set a Late Fee/Charges',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _lateFeeDaysController,
                      decoration:
                          const InputDecoration(labelText: 'Enter Days'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _lateFeeAmountController,
                      decoration:
                          const InputDecoration(labelText: 'Enter Amount'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRecurringDay,
                decoration:
                    const InputDecoration(labelText: 'Select Recurring Day'),
                items: ['1st', '2nd', '3rd', '4th', '5th']
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRecurringDay = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTenant,
                decoration: InputDecoration(
                  labelText: 'Select Tenant',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: _tenants.map((tenant) {
                  return DropdownMenuItem<String>(
                    value: tenant['_id'],
                    child: Text(tenant['tenantName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTenant = value;
                    _prefillRentDetails();
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a tenant';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRentDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("062356"),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save Rent',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.isFromSignUp)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandlordDashboard(
                          token: widget.token,
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
                    // Navigate back to PropertiesPage if accessed after login
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
}
