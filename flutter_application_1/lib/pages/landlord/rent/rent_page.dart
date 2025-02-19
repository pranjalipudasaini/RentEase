import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:flutter_application_1/pages/landlord/rent/view_rent.dart';
import 'package:flutter_application_1/pages/rent_details.dart';
import 'package:get/get.dart';

class RentPage extends GetView<RentController> {
  final RentController rentController = Get.find<RentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (rentController.rents.isEmpty) {
          return Center(
            child: TextButton(
              onPressed: rentController.fetchRents,
              child: const Text(
                "No rents found. Tap to retry.",
                style: TextStyle(color: Color(0xFF062356)),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: rentController.rents.length,
          itemBuilder: (context, index) {
            final rent = rentController.rents[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRentsPage(
                      rent: rent,
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
                      'Rent for ${rent['tenantName'] ?? 'Unnamed Tenant'}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062356),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Rent for ${rent['dueDate'] != null ? DateTime.parse(rent['dueDate']).toLocal().toString().split(' ')[0] : 'No due date provided'}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF062356)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RentDetailsPage(
                                  token: rentController.token.value,
                                  rent: rent,
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
                                title: const Text(
                                  "Delete Rent",
                                  style: TextStyle(color: Color(0xFF062356)),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this rent?",
                                  style: TextStyle(color: Color(0xFF4A78C9)),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel",
                                        style: TextStyle(
                                            color: Color(0xFF062356))),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      rentController.deleteRent(index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete",
                                        style: TextStyle(
                                            color: Color(0xFFF2B138))),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'rentsPageFab',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentDetailsPage(
                token: rentController.token.value,
              ),
            ),
          );
          rentController.fetchRents();
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
