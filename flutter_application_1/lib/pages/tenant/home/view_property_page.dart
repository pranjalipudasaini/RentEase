import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/submit_applications/submit_application_page.dart';
import 'package:flutter_application_1/pages/tenant/home/planned_tenant_home_controller.dart';
import 'package:get/get.dart';

class TenantViewPropertyPage extends StatelessWidget {
  final PlannedTenantHomeController propertyController =
      Get.put(PlannedTenantHomeController());
  final Map<String, dynamic> property;

  TenantViewPropertyPage({Key? key, required this.property}) : super(key: key);

  void navigateToApplicationPage(BuildContext context) {
    Get.to(() => SubmitApplicationPage(property: property));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(property['propertyName'] ?? 'Property Details',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Property Name: ${property['propertyName'] ?? 'Unnamed Property'}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Type: ${property['type'] ?? 'No type specified'}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Size: ${property['size']?.toStringAsFixed(2) ?? 'No size provided'} sq.ft.',
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 16.0),
            Center(
              child: OutlinedButton(
                onPressed: () => navigateToApplicationPage(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF062356)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Apply for a unit',
                  style: TextStyle(
                    color: Color(0xFF062356),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
