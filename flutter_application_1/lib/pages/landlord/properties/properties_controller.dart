import 'package:get/get.dart';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PropertiesController extends GetxController {
  RxList<Map<String, dynamic>> properties = <Map<String, dynamic>>[].obs;
  late final RxString token;

  void markAsAvailable(int index) {
    properties[index]['available'] = !(properties[index]['available'] ?? false);
    properties.refresh();
  }

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

  void addProperty(Map<String, dynamic> propertyData) async {
    try {
      if (token.value.isEmpty) {
        print("Error: Token is missing before adding property");
        Get.snackbar("Error", "Authorization token is missing.");
        return;
      }

      // Check for duplicate property name before proceeding
      bool nameExists = properties.any((property) =>
          property['propertyName'] != null &&
          property['propertyName'] == propertyData['propertyName']);

      if (nameExists) {
        Get.snackbar("Error", "A property with this name already exists.");
        return;
      }

      // Proceed with adding the property
      final response = await http.post(
        Uri.parse('http://localhost:3000/property/saveProperty'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(propertyData),
      );

      print("Add Property Response: ${response.body}");

      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        var newProperty = jsonResponse['property'];

        if (newProperty != null && newProperty['_id'] != null) {
          properties.add(newProperty); // Add the new property to the list
          Get.snackbar("Success", "Property added successfully");
        } else {
          Get.snackbar("Error", "Invalid property response: Missing ID");
        }
      } else {
        Get.snackbar("Error", "Failed to add property: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding property: $e");
    }
  }

  void updateProperty(
      String propertyId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/property/updateProperty/$propertyId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchProperties(); // Refresh the list
        Get.snackbar("Success", "Property updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update property");
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating property: $e");
    }
  }

  void deleteProperty(int index) async {
    try {
      final propertyId = properties[index]['_id']; // Ensure `_id` is present
      print("Property ID to delete: $propertyId");

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

  void toggleAvailability(String propertyId, bool currentStatus) async {
    try {
      // Optimistically update UI first
      int index = properties.indexWhere((p) => p['_id'] == propertyId);
      if (index != -1) {
        properties[index]['isAvailable'] = !currentStatus;
        properties.refresh(); // Ensures UI updates immediately
      }

      final response = await http.patch(
        Uri.parse(
            'http://localhost:3000/property/toggleAvailability/$propertyId'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        fetchProperties(); // Refresh the list after successful update
        Get.snackbar("Success", "Property availability updated");
      } else {
        // If the API call fails, revert the UI update
        if (index != -1) {
          properties[index]['isAvailable'] = currentStatus;
          properties.refresh();
        }
        Get.snackbar(
            "Error", "Failed to update availability: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
