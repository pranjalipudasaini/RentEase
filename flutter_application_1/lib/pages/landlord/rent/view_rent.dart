import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:flutter_application_1/pages/rent_details.dart';
import 'package:get/get.dart';

class ViewRentsPage extends StatelessWidget {
  final RentController rentsController = Get.put(RentController());
  final Map<String, dynamic> rent;

  ViewRentsPage({Key? key, required this.rent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(rent['rentName'] ?? 'Rent Details',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RentDetailsPage(
                    token: rentsController.token.value,
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
                  title: const Text("Delete Rent"),
                  content:
                      const Text("Are you sure you want to delete this rent?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logic to delete the rent
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
              'Rent Name: ${rent['rentName'] ?? 'Unnamed Rent'}',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Due Date: ${rent['dueDate'] != null ? DateTime.parse(rent['dueDate']).toLocal().toString().split(' ')[0] : 'No due date provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Other Charges: Rs.${rent['otherCharges']?.toStringAsFixed(2) ?? 'No charges provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Late Fee Days: ${rent['lateFeeCharges']?['days'] ?? 'No late fee days provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Late Fee Amount: Rs.${rent['lateFeeCharges']?['amount']?.toStringAsFixed(2) ?? 'No late fee amount provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Recurring Day: ${rent['recurringDay'] ?? 'Not specified'}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
