import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:get/get.dart';

class ViewPropertyPage extends StatelessWidget {
  final PropertiesController propertyController =
      Get.put(PropertiesController());
  final Map<String, dynamic> property;

  ViewPropertyPage({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(property['propertyName'] ?? 'Property Details',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetailsPage(
                    token: propertyController.token.value,
                    property: property,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Property"),
                  content: const Text(
                      "Are you sure you want to delete this property?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logic to delete the property
                        Navigator.pop(context);
                        Navigator.pop(context); // Go back to the previous page
                      },
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Property Name: ${property['propertyName'] ?? 'Unnamed Property'}',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Address: ${property['address'] ?? 'No address provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Country: ${property['country'] ?? 'No country provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'City: ${property['city'] ?? 'No city provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Furnishing: ${property['furnishing'] ?? 'No furnishing details provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Specifications',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Type: ${property['type'] ?? 'No type specified'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Size: ${property['propertySize']?.toStringAsFixed(2) ?? 'No size provided'} sq.ft.',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Road Type: ${property['roadType'] ?? 'No road type specified'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Kitchens: ${property['specifications']?['kitchens'] ?? 0}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Bathrooms: ${property['specifications']?['bathrooms'] ?? 0}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Bedrooms: ${property['specifications']?['bedrooms'] ?? 0}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Living Rooms: ${property['specifications']?['livingRooms'] ?? 0}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Amenities',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (property['amenities'] != null &&
                (property['amenities'] as List).isNotEmpty)
              ...((property['amenities'] as List)
                  .map((amenity) => Text(
                        '- $amenity',
                        style: const TextStyle(fontSize: 16.0),
                      ))
                  .toList())
            else
              const Text(
                'No amenities provided',
                style: TextStyle(fontSize: 16.0),
              ),
          ],
        ),
      ),
    );
  }
}
