import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:get/get.dart';

class PlannedTenantViewRent extends StatelessWidget {
  final RentController rentsController = Get.put(RentController());
  final Map<String, dynamic> rent;

  PlannedTenantViewRent({Key? key, required this.rent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(rent['rentName'] ?? 'Rent Details',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Tenant Name: ${rent['tenantName'] ?? 'Unnamed Tenant'}',
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
