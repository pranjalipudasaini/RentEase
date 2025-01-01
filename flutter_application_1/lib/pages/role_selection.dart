import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/tenant_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:snippet_coder_utils/hex_color.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  Future<void> updateUserRole(String role, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      print('SharedPreferences Email: $email'); // Debug log

      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User email not found')),
        );
        return;
      }

      final response = await http.put(
        Uri.parse('http://localhost:3000/updateRole'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': role, 'email': email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status']) {
          // Save the updated role and token to SharedPreferences
          var myToken = responseData['token'];

          if (myToken == null || myToken.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Token is null or empty')),
            );
            return; // Early exit if the token is invalid
          }

          await prefs.setString('token', myToken);
          await prefs.setString(
              'role', role); // Store role in SharedPreferences

          // Navigate to the appropriate dashboard
          if (role == 'landlord') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandlordDashboard(token: myToken),
              ),
            );
          } else if (role == 'tenant') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TenantDashboard(token: myToken),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(responseData['error'] ?? 'An unknown error occurred'),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> confirmLogout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm) {
      logout(context);
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logout button at the top
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () => confirmLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("D9E3F0"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),

            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50),
              width: double.infinity,
              color: HexColor("D9E3F0"),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    height: 80,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Role Selection Header
            const Text(
              'Select your role:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            // Role Selection Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => updateUserRole('landlord', context),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.key,
                              color: HexColor('062356'),
                              size: 60,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Property Manager',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Manage properties, track payments and handle maintenance requests.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => updateUserRole('tenant', context),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.home,
                              color: HexColor('062356'),
                              size: 60,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Tenant',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'View Rent Payments, make payments online and request maintenance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
