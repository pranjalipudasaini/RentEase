import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/tenant_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:snippet_coder_utils/hex_color.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String token;
  final bool isFromSignUp;

  const PropertyDetailsPage({
    Key? key,
    required this.token,
    final Map<String, dynamic>? property,
    this.isFromSignUp = false, // Default to false
  }) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _propertyNameController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCountry = 'Nepal';
  String? _selectedCity;
  String? _selectedFurnishing;
  String? _selectedType;
  String? _selectedRoadType;
  double _propertySize = 0;
  Map<String, bool> _amenities = {
    'Parking': false,
    'WiFi': false,
    'In-Unit Washer': false,
  };

  int _kitchenCount = 0;
  int _bathroomCount = 0;
  int _bedroomCount = 0;
  int _livingRoomCount = 0;

  Future<void> _savePropertyDetails() async {
    if (_formKey.currentState!.validate()) {
      final propertyDetails = {
        'token': widget.token,
        'propertyName': _propertyNameController.text,
        'address': _addressController.text,
        'country': _selectedCountry,
        'city': _selectedCity,
        'furnishing': _selectedFurnishing,
        'type': _selectedType,
        'propertySize': _propertySize,
        'kitchenCount': _kitchenCount,
        'bathroomCount': _bathroomCount,
        'bedroomCount': _bedroomCount,
        'livingRoomCount': _livingRoomCount,
        'roadType': _selectedRoadType,
        'amenities': _amenities.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/property/saveProperty'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode(propertyDetails),
        );

        if (response.statusCode == 201) {
          // Add the property to the controller
          Get.find<PropertiesController>().addProperty(propertyDetails);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Property saved successfully!')),
          );

          // Navigate based on whether it's from sign-up or login
          if (widget.isFromSignUp) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TenantDetailsPage(token: widget.token, isFromSignUp: true),
              ),
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LandlordDashboard(token: widget.token),
              ),
              (route) => false, // Remove all previous routes
            );
          }
        } else {
          print('Failed to save property: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save property')),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
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
          'Property Details',
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
              TextFormField(
                controller: _propertyNameController,
                decoration: const InputDecoration(labelText: 'Property Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the property name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(labelText: 'Country'),
                items: ['Nepal']
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: 'City'),
                items: [
                  'Kathmandu',
                  'Pokhara',
                  'Biratnagar',
                  'Bhaktapur',
                  'Lalitpur',
                  'Dharan',
                  'Birgunj'
                ]
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Specifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Apartment', 'House', 'Condo', 'Land']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Size (sq.ft.)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _propertySize = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Furnishing',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedFurnishing,
                decoration: const InputDecoration(labelText: 'Furnishing'),
                items: ['Furnished', 'Unfurnished', 'Semi-Furnished']
                    .map((furnishing) => DropdownMenuItem(
                          value: furnishing,
                          child: Text(furnishing),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFurnishing = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Road Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedRoadType,
                decoration: const InputDecoration(labelText: 'Road Type'),
                items: ['Paved', 'Unpaved']
                    .map((roadType) => DropdownMenuItem(
                          value: roadType,
                          child: Text(roadType),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoadType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Amenities',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Parking'),
                value: _amenities['Parking'],
                onChanged: (bool? value) {
                  setState(() {
                    _amenities['Parking'] = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('WiFi'),
                value: _amenities['WiFi'],
                onChanged: (bool? value) {
                  setState(() {
                    _amenities['WiFi'] = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('In-Unit Washer'),
                value: _amenities['In-Unit Washer'],
                onChanged: (bool? value) {
                  setState(() {
                    _amenities['In-Unit Washer'] = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildRoomCounter('Kitchens', _kitchenCount, (count) {
                setState(() {
                  _kitchenCount = count;
                });
              }),
              _buildRoomCounter('Bathrooms', _bathroomCount, (count) {
                setState(() {
                  _bathroomCount = count;
                });
              }),
              _buildRoomCounter('Bedrooms', _bedroomCount, (count) {
                setState(() {
                  _bedroomCount = count;
                });
              }),
              _buildRoomCounter('Living Rooms', _livingRoomCount, (count) {
                setState(() {
                  _livingRoomCount = count;
                });
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _savePropertyDetails,
                child: const Text('Save Property'),
              ),
              const SizedBox(height: 16),
              if (widget.isFromSignUp)
                TextButton(
                  onPressed: () {
                    // Navigate to TenantDetailsPage if accessed during sign-up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TenantDetailsPage(
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

  // Custom widget for incrementing room count
  Widget _buildRoomCounter(
      String roomType, int roomCount, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(roomType),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: roomCount > 0 ? () => onChanged(roomCount - 1) : null,
            ),
            Text('$roomCount'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(roomCount + 1),
            ),
          ],
        ),
      ],
    );
  }
}
