import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/tenants/tenant_controller.dart';
import 'package:flutter_application_1/pages/tenant_details.dart';
import 'package:get/get.dart';

class ViewTenantsPage extends StatelessWidget {
  final TenantController tenantsController = Get.put(TenantController());
  final Map<String, dynamic> tenant;

  ViewTenantsPage({Key? key, required this.tenant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(tenant['tenantName'] ?? 'Tenant Details',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TenantDetailsPage(
                    token: tenantsController.token.value,
                    // tenant: tenant,
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
                  title: const Text("Delete Tenant"),
                  content: const Text(
                      "Are you sure you want to delete this tenant?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logic to delete the tenant
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
              'Tenant Name: ${tenant['tenantName'] ?? 'Unnamed Tenant'}',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email: ${tenant['tenantEmail'] ?? 'No email provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Contact Number: ${tenant['tenantContactNumber'] ?? 'No contact provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Lease Start Date: ${tenant['leaseStartDate'] != null ? DateTime.parse(tenant['leaseStartDate']).toLocal().toString().split(' ')[0] : 'No lease start date provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Lease End Date: ${tenant['leaseEndDate'] != null ? DateTime.parse(tenant['leaseEndDate']).toLocal().toString().split(' ')[0] : 'No lease end date provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rent Amount: Rs.${tenant['rentAmount']?.toStringAsFixed(2) ?? 'No rent amount provided'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Property Information',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Property: ${tenant['propertyName'] ?? 'No property associated'}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Tenant ID: ${tenant['_id'] ?? 'No ID available'}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
