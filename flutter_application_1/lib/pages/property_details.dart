import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application_1/pages/landlord/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/tenant_details.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? property;
  final bool isFromSignUp;

  const PropertyDetailsPage({
    Key? key,
    required this.token,
    this.property,
    this.isFromSignUp = false,
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

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _populatePropertyDetails(widget.property!);
    }
  }

  void _populatePropertyDetails(Map<String, dynamic> property) {
    _propertyNameController.text = property['propertyName'] ?? '';
    _addressController.text = property['address'] ?? '';
    _selectedCountry = property['country'] ?? 'Nepal';
    _selectedCity = property['city'];
    _selectedFurnishing = property['furnishing'];
    _selectedType = property['type'];
    _selectedRoadType = property['roadType'];
    _propertySize = property['propertySize']?.toDouble() ?? 0;
    _kitchenCount = property['kitchenCount'] ?? 0;
    _bathroomCount = property['bathroomCount'] ?? 0;
    _bedroomCount = property['bedroomCount'] ?? 0;
    _livingRoomCount = property['livingRoomCount'] ?? 0;

    if (property['amenities'] != null) {
      for (var key in _amenities.keys) {
        _amenities[key] = property['amenities'].contains(key);
      }
    }
  }

  Future<void> _savePropertyDetails() async {
    if (_formKey.currentState!.validate()) {
      // Manual validation for required fields
      if (_propertyNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property name cannot be empty')),
        );
        return;
      }

      if (_selectedCity == null || _selectedCity!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a city')),
        );
        return;
      }

      if (_selectedCountry.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      }

      final propertyDetails = {
        'token': widget.token,
        'propertyName': _propertyNameController.text.trim(),
        'address': _addressController.text.trim(),
        'country': _selectedCountry,
        'city': _selectedCity ?? '',
        'furnishing': _selectedFurnishing ?? '',
        'type': _selectedType ?? '',
        'propertySize': _propertySize,
        'kitchenCount': _kitchenCount,
        'bathroomCount': _bathroomCount,
        'bedroomCount': _bedroomCount,
        'livingRoomCount': _livingRoomCount,
        'roadType': _selectedRoadType ?? '',
        'amenities': _amenities.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
      };

      try {
        final uri = widget.property == null
            ? Uri.parse('http://localhost:3000/property/saveProperty')
            : Uri.parse(
                'http://localhost:3000/property/updateProperty/${widget.property!['_id']}');

        final response = widget.property == null
            ? await http.post(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                },
                body: jsonEncode(propertyDetails),
              )
            : await http.put(
                uri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                },
                body: jsonEncode(propertyDetails),
              );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Get.find<PropertiesController>().fetchProperties();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Property saved successfully!')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LandlordDashboard(token: widget.token),
            ),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save property')),
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
                    _selectedCity = value;
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

  Widget _buildRoomCounter(String label, int count, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (count > 0) {
                  setState(() {
                    onChanged(count - 1);
                  });
                }
              },
            ),
            Text(count.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  onChanged(count + 1);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
