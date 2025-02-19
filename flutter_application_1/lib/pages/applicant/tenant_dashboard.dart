import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

class TenantDashboard extends StatefulWidget {
  final String token;
  const TenantDashboard({required this.token, Key? key}) : super(key: key);

  @override
  State<TenantDashboard> createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard> {
  late String email;

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

      if (jwtDecodedToken.containsKey('email')) {
        email = jwtDecodedToken['email'];
      } else {
        email = 'No email found';
      }
    } catch (e) {
      email = 'Invalid token';
    }
  }

  Future<void> logout() async {
    // Clear the shared preferences (if you're using it to store the token)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Redirect to the login page
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the tenant dashboard, $email!'),
          ],
        ),
      ),
    );
  }
}
