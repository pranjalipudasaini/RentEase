import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/applicant/home/home_controller.dart';
import 'package:flutter_application_1/pages/applicant/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:flutter_application_1/pages/landlord/home/home_controller.dart';
import 'package:flutter_application_1/pages/landlord/landlord_dashboard.dart';
import 'package:flutter_application_1/pages/landlord/properties/properties_controller.dart';
import 'package:flutter_application_1/pages/landlord/rent/rent_controller.dart';
import 'package:flutter_application_1/pages/landlord/tenants/tenant_controller.dart';
import 'package:flutter_application_1/pages/property_details.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'package:flutter_application_1/pages/applicant/tenant_dashboard.dart';
import 'package:get/get.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AuthService().init());
  Get.put(HomeController());
  Get.put(PropertiesController());
  Get.put(TenantController());
  Get.put(RentController());
  Get.put(ApplicantHomeController());
  Get.put(ApplicantPropertiesController());
  // Run the app
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
        // Correct route handling with `else if` and proper `arguments` checking
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const LoginPage(),
          );
        } else if (settings.name == '/register') {
          return MaterialPageRoute(
            builder: (context) => const SignUpPage(),
          );
        } else if (settings.name == '/tenantDashboard') {
          if (settings.arguments != null && settings.arguments is String) {
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => TenantDashboard(token: token),
            );
          } else {
            return _errorRoute();
          }
        } else if (settings.name == '/landlordDashboard') {
          if (settings.arguments != null && settings.arguments is String) {
            final token = settings.arguments as String;

            // Manually initialize the required controllers
            if (!Get.isRegistered<PropertiesController>()) {
              Get.put(PropertiesController());
            }
            if (!Get.isRegistered<RentController>()) {
              Get.put(RentController());
            }
            if (!Get.isRegistered<TenantController>()) {
              Get.put(TenantController());
            }

            return MaterialPageRoute(
              builder: (context) => LandlordDashboard(token: token),
            );
          } else {
            return _errorRoute();
          }
        } else if (settings.name == '/propertyDetails') {
          if (settings.arguments != null && settings.arguments is String) {
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => PropertyDetailsPage(token: token),
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
