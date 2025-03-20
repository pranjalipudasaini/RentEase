import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/payments/planned_tenant_view_rent.dart';
import 'package:get/get.dart';
import 'planned_tenant_payments_controller.dart';

class PlannedTenantPayments extends GetView<PlannedTenantPaymentsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rent Details",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062356),
              ),
            ),
            const SizedBox(height: 12.0),
            Obx(() {
              if (controller.rent.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final Map<String, dynamic> rent =
                  Map<String, dynamic>.from(controller.rent);

              return GestureDetector(
                onTap: () {
                  Get.to(() => PlannedTenantViewRent(rent: rent));
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(
                          color: Color(0xFF062356), width: 2.0),
                    ),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tenant: ${rent['tenantName'] ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF062356),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text("Due Date: ${rent['dueDate'] ?? 'N/A'}"),
                          const SizedBox(height: 6.0),
                          Text("Other Charges: \$${rent['otherCharges'] ?? 0}"),
                          const SizedBox(height: 6.0),
                          Text(
                              "Late Fee: \$${rent['lateFeeCharges']['amount'] ?? 0}"),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Payment Logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF062356),
                            ),
                            child: const Text("Pay Now",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
