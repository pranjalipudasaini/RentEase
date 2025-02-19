import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/pages/landlord/rent/view_rent.dart';
import 'package:flutter_application_1/pages/landlord/tenants/view_tenant.dart';
import 'package:flutter_application_1/pages/landlord/properties/view_property.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard_controller.dart';

class HomePage extends GetView<HomeController> {
  final String email;

  const HomePage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, "My Properties", 1),
            _buildPropertyList(),
            _buildSectionHeader(context, "My Tenants", 2),
            _buildTenantList(),
            _buildSectionHeader(context, "Recent Rents", 3),
            _buildRentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int tabIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Provider.of<LandlordDashboardController>(context, listen: false)
                .onTabTapped(tabIndex);
          },
          child: const Text(
            "View All",
            style: TextStyle(
              color: Color(0xFF062356),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyList() {
    return Obx(() {
      if (controller.properties.isEmpty) {
        return _buildEmptyState(
            controller.fetchProperties, "No properties found. Tap to retry.");
      }

      return Column(
        children: controller.properties.take(2).map((property) {
          return _buildInfoCard(
            property['propertyName'] ?? 'Unnamed Property',
            property['address'] ?? 'No address provided',
            () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => ViewPropertyPage(property: property),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildTenantList() {
    return Obx(() {
      if (controller.tenants.isEmpty) {
        return _buildEmptyState(
            controller.fetchTenants, "No tenants found. Tap to retry.");
      }

      return Column(
        children: controller.tenants.take(2).map((tenant) {
          return _buildInfoCard(
            tenant['tenantName'] ?? 'Unknown Tenant',
            tenant['email'] ?? 'No email provided',
            () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => ViewTenantsPage(tenant: tenant),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildRentList() {
    return Obx(() {
      if (controller.rents.isEmpty) {
        return _buildEmptyState(
            controller.fetchRents, "No rent records found. Tap to retry.");
      }

      return Column(
        children: controller.rents.take(2).map((rent) {
          return _buildInfoCard(
            "Rent: ${rent['rentAmount'] ?? 'Unknown'}",
            "Due Date: ${rent['dueDate'] ?? 'No due date'}",
            () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => ViewRentsPage(rent: rent),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildInfoCard(String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF062356),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(VoidCallback onTap, String message) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        child: Text(message),
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF062356),
        ),
      ),
    );
  }
}
