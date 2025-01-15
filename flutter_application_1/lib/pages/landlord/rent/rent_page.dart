import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:flutter_application_1/pages/rent_details.dart';
import 'package:get/get.dart';

class RentPage extends GetView<RentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rent Page'),
      ),
      body: Obx(() {
        // Show loading spinner until the rents data is loaded
        if (controller.rents.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: controller.rents.length,
          itemBuilder: (context, index) {
            final rent = controller.rents[index];
            return ListTile(
              title: Text(
                  'Rent for ${rent['propertyName'] ?? 'Unnamed Property'}'),
              subtitle: Text('Due Date: ${rent['dueDate'] ?? 'N/A'}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'rentPageFab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RentDetailsPage(token: controller.token.value),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
