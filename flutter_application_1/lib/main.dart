import 'package:flutter/material.dart';
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
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );

          case '/register':
            return MaterialPageRoute(
              builder: (context) => const SignUpPage(),
            );

          case '/tenantDashboard':
            if (settings.arguments != null && settings.arguments is String) {
              final token = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => TenantDashboard(token: token),
              );
            } else {
              return _errorRoute();
            }

          default:
            return _errorRoute();
        }
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
