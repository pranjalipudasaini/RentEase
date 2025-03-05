import 'dart:convert';
import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LandlordApplicationController extends GetxController {
  var applications = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<AuthService>().token;
    fetchApplicationsForLandlord();
  }

  void fetchApplicationsForLandlord() async {
    try {
      print("Fetching landlord applications...");

      final response = await http.get(
        Uri.parse('http://localhost:3000/application/getLandlordApplications'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['success'] != null) {
          applications.value =
              List<Map<String, dynamic>>.from(jsonResponse['success']);
        } else {
          applications.clear();
          Get.snackbar('Info', 'No applications found.');
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch landlord applications: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
