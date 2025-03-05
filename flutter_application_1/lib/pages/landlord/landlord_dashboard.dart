import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/applications/landlord_application_page.dart';
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
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    controller.logout(context);
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF062356),
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.build),
                    title: Text('Maintenance'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: Text('Applications'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LandlordApplicationPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart),
                    title: Text('Report'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.task),
                    title: Text('Tasks'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.announcement),
                    title: Text('Announcement'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out'),
                    onTap: () {
                      controller.logout(context);
                    },
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: controller.selectedIndex,
              children: controller.pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: controller.selectedIndex,
              onTap: controller.onTabTapped,
              selectedItemColor: Color(0xFF062356),
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
