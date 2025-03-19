import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/tenant/tenant_plan_controller.dart';

class TenantPlanDashboard extends StatelessWidget {
  final String token;

  const TenantPlanDashboard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TenantPlanDashboardController controller =
        Get.put(TenantPlanDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tenant Dashboard",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: controller.logout, // No need to pass context
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.pages.isNotEmpty
                ? controller.pages
                : [const Center(child: CircularProgressIndicator())],
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onTabTapped,
          selectedItemColor: const Color(0xFF062356),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment), label: 'Payments'),
            BottomNavigationBarItem(
                icon: Icon(Icons.request_page), label: 'Requests'),
            BottomNavigationBarItem(
                icon: Icon(Icons.announcement), label: 'Announcements'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
