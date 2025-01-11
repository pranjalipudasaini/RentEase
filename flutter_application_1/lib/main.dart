import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'package:flutter_application_1/pages/tenant_dashboard.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name case '/') {
          return MaterialPageRoute(
            builder: (context) => const LoginPage(),
          );
        } else if (settings.name case '/register') {
          return MaterialPageRoute(
            builder: (context) => const SignUpPage(),
          );
        } else if (settings.name case '/tenantDashboard') {
          if (settings.arguments != null && settings.arguments is String) {
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => TenantDashboard(token: token),
            );
          } else {
            return _errorRoute();
          }
        } else if (settings.name case '/landlordDashboard') {
          if (settings.arguments != null && settings.arguments is String) {
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => LandlordDashboard(token: token),
            );
          } else {
            return _errorRoute();
          }
        } else if (settings.name == '/propertyDetails') {
          if (settings.arguments != null && settings.arguments is String) {
            final landlordId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => PropertyDetailsPage(landlordId: landlordId),
            );
          } else {
            return _errorRoute();
          }
        }
        return null;
      },
    );
  }

  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("Page not found!"),
        ),
      ),
    );
  }
}
