import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord_dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:intl/intl.dart';

class RentDetailsPage extends StatefulWidget {
  final double rentAmount;
  final String token;

  const RentDetailsPage({
    Key? key,
    required this.rentAmount,
    required this.token,
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

  String _selectedRecurringDay = '1st';

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

  Future<void> _saveRentDetails() async {
    if (_formKey.currentState!.validate()) {
      final rentDetails = {
        "rentAmount": widget.rentAmount,
        "dueDate": _dueDateController.text,
        "otherCharges": double.tryParse(_otherChargesController.text) ?? 0,
        "lateFeeCharges": {
          "days": int.tryParse(_lateFeeDaysController.text) ?? 0,
          "amount": double.tryParse(_lateFeeAmountController.text) ?? 0,
        },
        "recurringDay": _selectedRecurringDay,
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/rent/saveRent'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}",
          },
          body: jsonEncode(rentDetails),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rent details saved successfully!')),
          );

          // Navigate to Landlord Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandlordDashboard(token: widget.token),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save rent: ${response.body}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $error')),
        );
      }
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
              ElevatedButton(
                onPressed: _saveRentDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("062356"),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
