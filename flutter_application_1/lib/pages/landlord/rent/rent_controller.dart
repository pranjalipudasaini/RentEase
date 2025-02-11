import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RentController extends GetxController {
  var rents = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<AuthService>().token;
    fetchRents();
  }

  Future<String> fetchTenantName(String tenantId) async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/tenant/getTenant/$tenantId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['tenantName'] ?? 'Unknown Tenant';
      } else {
        print("Failed to load tenant name: ${response.statusCode}");
        return 'Unknown Tenant';
      }
    } catch (e) {
      print("Error fetching tenant name: $e");
      return 'Unknown Tenant';
    }
  }

  void addRent(Map<String, dynamic> rentData) async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar("Error", "Authorization token is missing.");
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/rent/saveRent'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(rentData),
      );

      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        var newRent = jsonResponse['rent'];

        if (newRent != null && newRent['_id'] != null) {
          rents.add(newRent);
          Get.snackbar("Success", "Rent added successfully");
        } else {
          Get.snackbar("Error", "Invalid rent response: Missing ID");
        }
      } else {
        Get.snackbar("Error", "Failed to add rent: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding rent: $e");
    }
  }

  void fetchRents() async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar('Error', 'Token is missing, unable to fetch rents');
        return;
      }

      print("Fetching rents with token: '${token.value}'");

      final response = await http.get(
        Uri.parse('http://localhost:3000/rent/getRent'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['status'] == true) {
          if (jsonResponse.containsKey('success') &&
              jsonResponse['success'] is List) {
            rents.value =
                List<Map<String, dynamic>>.from(jsonResponse['success']);
          } else {
            print("Unexpected API response format: $jsonResponse");
            Get.snackbar('Error', 'Invalid rent data format received');
          }
        } else {
          print("Failed to fetch rents: ${jsonResponse}");
          Get.snackbar('Error',
              'Failed to fetch rents: ${jsonResponse['message'] ?? 'Unknown error'}');
        }
      } else {
        print("Error fetching rents: ${response.body}");
        Get.snackbar('Error', 'Failed to fetch rents: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception fetching rents: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void updateRent(String rentId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/rent/updateRent/$rentId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchRents(); // Refresh the list
        Get.snackbar("Success", "Rent updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update rent");
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating rent: $e");
    }
  }

  void deleteRent(int index) async {
    try {
      final rentId = rents[index]['_id'];

      if (rentId == null) {
        Get.snackbar("Error", "Invalid Rent ID");
        return;
      }

      var response = await http.delete(
        Uri.parse('http://localhost:3000/rent/deleteRent/$rentId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        rents.removeAt(index);
        Get.snackbar("Success", "Rent deleted successfully");
      } else {
        Get.snackbar("Error", "Failed to delete rent: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting rent: $e");
    }
  }
}
