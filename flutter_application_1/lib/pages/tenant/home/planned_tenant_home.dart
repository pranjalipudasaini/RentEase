import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'planned_tenant_home_controller.dart';
import 'view_property_page.dart';

class PlannedTenantHome extends GetView<PlannedTenantHomeController> {
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
              "My Property",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062356),
              ),
            ),
            const SizedBox(height: 12.0),
            Obx(() {
              if (controller.property.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final Map<String, dynamic> property =
                  Map<String, dynamic>.from(controller.property);

              return GestureDetector(
                onTap: () {
                  Get.to(() => TenantViewPropertyPage(property: property));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side:
                        const BorderSide(color: Color(0xFF062356), width: 2.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
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
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFF062356)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  property['address'] ?? 'No address provided',
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            children: [
                              const Icon(Icons.location_city,
                                  color: Color(0xFF062356)),
                              const SizedBox(width: 6),
                              Text(
                                property['city'] ?? 'No city specified',
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                              ),
                            ],
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
