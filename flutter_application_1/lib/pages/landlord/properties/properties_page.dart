import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:get/get.dart';

class PropertiesPage extends GetView<PropertiesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Properties'),
      ),
      body: Obx(() {
        if (controller.token.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.properties.isEmpty) {
          return const Center(
            child: Text(
              "No properties added yet",
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.properties.length,
          itemBuilder: (context, index) {
            final property = controller.properties[index];
            return ListTile(
              title: Text(property['propertyName'] ?? 'Unnamed Property'),
              subtitle: Text(property['address'] ?? 'No address provided'),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.token.isEmpty) {
          return const SizedBox.shrink(); // Hide the FAB if token is not ready
        }
        return FloatingActionButton(
          heroTag: 'propertiesPageFab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PropertyDetailsPage(token: controller.token.value),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        );
      }),
    );
  }
}
