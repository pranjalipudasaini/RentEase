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
    _loadTenants();
  }

  void _loadTenants() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/tenants/getTenants'),
        headers: {
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        tenants.value = List<Map<String, dynamic>>.from(data);
      } else {
        print("Failed to load tenants: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading tenants: $e");
    }
  }

  void addTenant(Map<String, dynamic> tenant) {
    tenants.add(tenant);
  }
}
