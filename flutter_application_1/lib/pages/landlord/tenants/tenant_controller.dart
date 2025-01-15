import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantController extends GetxController {
  var tenants = <Map<String, dynamic>>[].obs; // Observable list of properties
  var token = ''.obs; // Observable token

  @override
  void onInit() {
    super.onInit();
    _loadToken(); // Load token when the controller is initialized
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');
    if (storedToken == null || storedToken.isEmpty) {
      print("Error: Token is missing!");
    } else {
      token.value = storedToken;
    }
  }

  void addTenant(Map<String, dynamic> tenant) {
    tenants.add(tenant);
  }
}
