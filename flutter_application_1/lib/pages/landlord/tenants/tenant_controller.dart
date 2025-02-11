import 'package:get/get.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TenantController extends GetxController {
  var tenants = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<AuthService>().token;
    fetchTenants();
  }

  Future<String> fetchPropertyName(String propertyId) async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/property/getProperty/$propertyId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['propertyName'] ?? 'Unknown Property';
      } else {
        print("Failed to load property name: ${response.statusCode}");
        return 'Unknown Property';
      }
    } catch (e) {
      print("Error fetching property name: $e");
      return 'Unknown Property';
    }
  }

  void addTenant(Map<String, dynamic> tenantData) async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar("Error", "Authorization token is missing.");
        return;
      }

      // Check for duplicate tenant before making the API call
      bool tenantExists = tenants.any((tenant) =>
          tenant['email'] == tenantData['email']); // Use email for uniqueness

      if (tenantExists) {
        Get.snackbar("Error", "A tenant with this email already exists.");
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/tenant/saveTenant'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tenantData),
      );

      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        var newTenant = jsonResponse['tenant'];

        if (newTenant != null && newTenant['_id'] != null) {
          tenants.add(newTenant);
          Get.snackbar("Success", "Tenant added successfully");
        } else {
          Get.snackbar("Error", "Invalid tenant response: Missing ID");
        }
      } else {
        Get.snackbar("Error", "Failed to add tenant: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding tenant: $e");
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

  void updateTenant(String tenantId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/tenant/updateTenant/$tenantId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchTenants(); // Refresh the list
        Get.snackbar("Success", "Tenant updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update tenant");
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating tenant: $e");
    }
  }

  void deleteTenant(int index) async {
    try {
      final tenantId = tenants[index]['_id'];

      if (tenantId == null) {
        Get.snackbar("Error", "Invalid Tenant ID");
        return;
      }

      var response = await http.delete(
        Uri.parse('http://localhost:3000/tenant/deleteTenant/$tenantId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        tenants.removeAt(index);
        Get.snackbar("Success", "Tenant deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete tenant: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting tenant: $e");
    }
  }
}
