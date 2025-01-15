import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard_controller.dart';
import 'package:provider/provider.dart';

class LandlordDashboard extends StatelessWidget {
  final String token;

  const LandlordDashboard({required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandlordDashboardController(token),
      child: Consumer<LandlordDashboardController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Landlord Dashboard'),
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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.selectedIndex,
              onTap: controller.onTabTapped,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
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
                  icon: Icon(Icons.people),
                  label: 'Tenants',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Rent',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
