import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/landlord/auth_service.dart';

class RentController extends GetxController {
  var rents = <Map<String, dynamic>>[].obs;
  late final RxString token;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<AuthService>().token;
    _loadRents();
  }

  Future<void> _loadRents() async {
    try {
      var response = await http
          .get(Uri.parse('http://localhost:3000/rent/getRents'), headers: {
        'Authorization': 'Bearer ${token.value}',
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        rents.value = List<Map<String, dynamic>>.from(data);
      } else {
        print("Failed to load rents: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading rents: $e");
    }
  }

  void addRent(Map<String, dynamic> rent) {
    rents.add(rent);
  }
}
