import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/tenants/tenant_controller.dart';
import 'package:flutter_application_1/pages/landlord/tenants/view_tenant.dart';
import 'package:flutter_application_1/pages/tenant_details.dart';
import 'package:get/get.dart';

class TenantPage extends GetView<TenantController> {
  final TenantController tenantController = Get.find<TenantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (tenantController.tenants.isEmpty) {
          return Center(
            child: TextButton(
              onPressed: tenantController.fetchTenants,
              child: const Text(
                "No tenants found. Tap to retry.",
                style: TextStyle(color: Color(0xFF062356)),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: tenantController.tenants.length,
          itemBuilder: (context, index) {
            final tenant = tenantController.tenants[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTenantsPage(
                      tenant: tenant,
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
                      tenant['tenantName'] ?? 'Unnamed Tenant',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF062356),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      tenant['tenantEmail'] ?? 'No email provided',
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
                                builder: (context) => TenantDetailsPage(
                                  token: tenantController.token.value,
                                  tenant: tenant,
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
                                  "Delete Tenant",
                                  style: TextStyle(color: Color(0xFF062356)),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this tenant?",
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
                                      tenantController.deleteTenant(index);
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
        heroTag: 'tenantsPageFab',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TenantDetailsPage(
                token: tenantController.token.value,
              ),
            ),
          );
          tenantController.fetchTenants();
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
