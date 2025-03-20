import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlannedTenantPaymentsController extends GetxController {
  var rent = {}.obs; // Observable property

  @override
  void onInit() {
    super.onInit();
    fetchRent();
  }

  Future<void> fetchRent() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:3000/rent/getSingleRent"),
        headers: {"Authorization": "Bearer yourToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          rent.value = data['rent'];
        }
      } else {
        print("Error fetching rent: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
