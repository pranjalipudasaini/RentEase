import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/tenant/tenant_plan_dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final String token;

  OTPVerificationPage(
      {required this.email, required this.token}); // Ensure token is required

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  String errorMessage = "";
  bool isLoading = false;

  Future<void> verifyOTP() async {
    String otpCode = controllers.map((c) => c.text).join();

    if (otpCode.length != 6) {
      setState(() {
        errorMessage = "Please enter a 6-digit code.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/verify-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": widget.email, "otp": otpCode}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["status"] == true) {
        // Navigate to Tenant Plan Dashboard with the correct token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TenantPlanDashboard(token: widget.token),
          ),
        );
      } else {
        setState(() {
          errorMessage =
              responseData["error"] ?? "Invalid OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Enter Code", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF062356),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the 6-digit code received in your email address to join a plan.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: "", // Hide character counter
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : GestureDetector(
                    onTap: verifyOTP,
                    child: const Text(
                      "Enter",
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
