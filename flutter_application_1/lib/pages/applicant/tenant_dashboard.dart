import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/tenant_dashboard_controller.dart';
import 'package:provider/provider.dart';

class TenantDashboard extends StatelessWidget {
  final String token;

  const TenantDashboard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TenantDashboardController(token),
      child: Consumer<TenantDashboardController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Tenant Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    controller.logout(context); // Use the controller to log out
                  },
                ),
              ],
            ),
            body: IndexedStack(
              index: controller.selectedIndex,
              children: controller.pages,
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                BottomNavigationBar(
                  backgroundColor: Colors.white,
                  currentIndex: controller.selectedIndex,
                  onTap: controller.onTabTapped,
                  selectedItemColor: Color(0xFF062356),
                  unselectedItemColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_location_alt),
                      label: 'Properties',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.article_rounded),
                      label: 'Applications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.help),
                      label: 'Help',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
