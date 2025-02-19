import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/landlord/properties/view_property.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:get/get.dart';

class PropertiesPage extends GetView<PropertiesController> {
  final PropertiesController propertyController =
      Get.find<PropertiesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Obx(() {
        if (propertyController.properties.isEmpty) {
          return Center(
            child: TextButton(
              onPressed: propertyController.fetchProperties,
              child: const Text("No properties found. Tap to retry."),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF062356),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: propertyController.properties.length,
          itemBuilder: (context, index) {
            final property = propertyController.properties[index];
            final bool isAvailable = property['isAvailable'] ?? false;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPropertyPage(
                      property: property,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFF062356),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property['propertyName'] ?? 'Unnamed Property',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062356),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      property['address'] ?? 'No address provided',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            propertyController.toggleAvailability(
                                property['_id'], isAvailable);
                          },
                          child: Text(
                            isAvailable
                                ? "Mark as Unavailable"
                                : "Mark as Available",
                            style: TextStyle(
                              color: isAvailable
                                  ? Color(0xFFF2B138)
                                  : Color(0xFF0FA3B1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF062356)),
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
                                          propertyController
                                              .deleteProperty(index);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsPage(
                token: propertyController.token.value,
              ),
            ),
          );
          propertyController.fetchProperties();
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF062356),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
