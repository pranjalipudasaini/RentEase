import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlannedTenantHomeController extends GetxController {
  var property = {}.obs; // Observable property

  @override
  void onInit() {
    super.onInit();
    fetchProperty();
  }

  Future<void> fetchProperty() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:3000/property/getSingleProperty"),
        headers: {"Authorization": "Bearer yourToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          property.value = data['property'];
        }
      } else {
        print("Error fetching property: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
