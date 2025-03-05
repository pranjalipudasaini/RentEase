import 'dart:convert';
import 'package:flutter_application_1/pages/applicant/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApplicationsController extends GetxController {
  var applications = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<TenantAuthService>().token;
    fetchApplications();
  }

  void fetchApplications() async {
    try {
      if (token.value.isEmpty) {
        Get.snackbar('Error', 'Token is missing, unable to fetch applications');
        return;
      }

      print("Authorization Token Before Request: '${token.value}'");

      final response = await http.get(
        Uri.parse('http://localhost:3000/application/getApplication'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      print("Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          applications.value =
              List<Map<String, dynamic>>.from(jsonResponse['success']);
        } else {
          Get.snackbar('Error', 'No applications found');
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to fetch applications: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
