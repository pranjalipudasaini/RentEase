import 'package:get/get.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PropertiesController extends GetxController {
  var properties = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<AuthService>().token;
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      print("Authorization Token: ${token.value}"); // Debugging

      final response = await http.get(
        Uri.parse('http://localhost:3000/property/getProperty'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Fetched Properties: $jsonResponse"); // Debugging

        if (jsonResponse['status'] == true) {
          properties.value =
              List<Map<String, dynamic>>.from(jsonResponse['success']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch properties');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void addProperty(Map<String, dynamic> property) {
    properties.add(property);
  }

  void deleteProperty(int index) async {
    try {
      final propertyId = properties[index]['_id']; // Ensure this field exists
      print("Property ID to delete: $propertyId"); // Debugging

      if (propertyId == null) {
        Get.snackbar("Error", "Invalid Property ID");
        return;
      }

      var response = await http.delete(
        Uri.parse('http://localhost:3000/property/deleteProperty/$propertyId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        properties.removeAt(index);
        Get.snackbar("Success", "Property deleted successfully");
      } else {
        Get.snackbar(
            "Error", "Failed to delete property: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error deleting property: $e");
    }
  }
}
