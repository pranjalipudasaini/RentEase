import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant_details.dart';
import 'package:get/get.dart';
import 'tenant_controller.dart';

class TenantPage extends StatelessWidget {
  final TenantController tenantController = Get.put(TenantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tenant Page'),
      ),
      body: Obx(() {
        if (tenantController.tenants.isEmpty) {
          return const Center(
            child: Text(
              "No tenants added yet",
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          itemCount: tenantController.tenants.length,
          itemBuilder: (context, index) {
            final tenant = tenantController.tenants[index];
            return ListTile(
              title: Text(tenant['tenantName'] ?? 'Unnamed Tenant'),
              subtitle: Text(tenant['tenantEmail'] ?? 'No email provided'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tenantPageFab',
        onPressed: () {
          String token = tenantController.token.value;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TenantDetailsPage(token: token),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
