import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApplicantPropertiesController extends GetxController {
  RxList<Map<String, dynamic>> properties = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();

    final authService = Get.find<AuthService>();
    token = authService.token;

    print("Retrieved Token: ${token.value}");
    if (token.value.isNotEmpty) {
      fetchAvailableProperties(token.value);
    } else {
      print("Error: Token is missing when fetching properties");
    }
  }

  Future<List<dynamic>> fetchAvailableProperties(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/property/availableProperties'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['properties'];
    } else {
      throw Exception("Failed to load properties");
    }
  }
}
