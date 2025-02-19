import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/home/home_page.dart';
import 'package:flutter_application_1/pages/applicant/profile/profile_page.dart';
import 'package:flutter_application_1/pages/applicant/help/help_page.dart';
import 'package:flutter_application_1/pages/applicant/applications/applications_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/pages/applicant/properties/properties_page.dart';

class TenantDashboardController extends ChangeNotifier {
  final String token;
  late String email;
  int selectedIndex = 0;

  // Pages for navigation
  late final List<Widget> pages;

  TenantDashboardController(this.token) {
    _decodeToken();
    _initializePages();
  }

  // Decode the JWT token to extract useful information
  void _decodeToken() {
    try {
      if (token.isNotEmpty) {
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
        email = jwtDecodedToken['email'] ?? 'No email found';
      } else {
        email = 'Invalid token';
      }
    } catch (e) {
      email = 'Email not found';
      print("Error decoding token: $e");
    }
  }

  // Initialize the pages for navigation
  void _initializePages() {
    pages = [
      ApplicantHomePage(email: email),
      ApplicantPropertiesPage(),
      ApplicationsPage(),
      HelpPage(),
      ApplicantProfilePage(),
    ];
  }

  // Change the selected page when the tab is tapped
  void onTabTapped(int index) {
    selectedIndex = index;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Logout functionality
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token from SharedPreferences

    // Navigate back to the Login Page using Navigator.pushAndRemoveUntil
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) =>
          false, // This will remove all previous routes and go to LoginPage
    );
  }
}
