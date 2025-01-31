import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:flutter_application_1/pages/rent_details.dart';
import 'package:get/get.dart';

class RentPage extends GetView<RentController> {
  final RentController rentController = Get.put(RentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (rentController.rents.isEmpty) {
          return const Center(
            child: Text(
              "No rents added yet",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        return ListView.builder(
          itemCount: rentController.rents.length,
          itemBuilder: (context, index) {
            final rent = rentController.rents[index];
            return ListTile(
              title: Text('Rent for ${rent['propertyName'] ?? 'Property01'}'),
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
                  RentDetailsPage(token: rentController.token.value),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
