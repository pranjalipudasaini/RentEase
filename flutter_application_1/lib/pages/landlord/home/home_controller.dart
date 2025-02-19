import 'dart:convert';

import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var properties = <Map<String, dynamic>>[].obs;
  var tenants = <Map<String, dynamic>>[].obs;
  var rents = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();

    final authService = Get.find<AuthService>();
    token = authService.token;

    print("Retrieved Token: ${token.value}");
    if (token.value.isNotEmpty) {
      fetchProperties();
    } else {
      print("Error: Token is missing when fetching properties");
    }
  }

  void fetchProperties() async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar('Error', 'Token is missing, unable to fetch properties');
        return;
      }

      print("Authorization Token Before Request: '${token.value}'");

      final response = await http.get(
        Uri.parse('http://localhost:3000/property/getProperty'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          // Validate and filter out properties with missing data
          properties.value = List<Map<String, dynamic>>.from(
              jsonResponse['success'].where((property) =>
                  property['_id'] != null && property['propertyName'] != null));
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch properties: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void fetchTenants() async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar('Error', 'Token is missing, unable to fetch tenants');
        return;
      }

      print("Authorization Token Before Request: '${token.value}'");

      final response = await http.get(
        Uri.parse('http://localhost:3000/tenant/getTenant'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          // Validate and filter out tenants with missing data
          tenants.value = List<Map<String, dynamic>>.from(
              jsonResponse['success'].where((tenant) =>
                  tenant['_id'] != null && tenant['tenantName'] != null));
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch tenants: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void fetchRents() async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar('Error', 'Token is missing, unable to fetch rents');
        return;
      }

      print("Authorization Token Before Request: '${token.value}'");

      final response = await http.get(
        Uri.parse('http://localhost:3000/rent/getRent'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          // Validate and filter out rents with missing data
          rents.value = List<Map<String, dynamic>>.from(jsonResponse['success']
              .where(
                  (rent) => rent['_id'] != null && rent['rentName'] != null));
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch rents: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
