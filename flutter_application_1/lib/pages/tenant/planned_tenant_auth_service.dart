import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlannedTenantAuthService extends GetxService {
  RxString token = ''.obs;
  RxString email = ''.obs;

  Future<PlannedTenantAuthService> init() async {
    await _loadToken();
    return this;
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');
    String? storedEmail = prefs.getString('email');

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
    }

    if (storedEmail != null && storedEmail.isNotEmpty) {
      email.value = storedEmail;
    }

    print("Stored Token: $storedToken, Stored Email: $storedEmail");
  }

  Future<void> saveToken(String newToken, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    await prefs.setString('email', userEmail); // ✅ Ensure email is stored

    token.value = newToken;
    email.value = userEmail;

    print("DEBUG: Token saved: $newToken");
    print("DEBUG: Email saved: $userEmail");
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    token.value = '';
    email.value = '';
    print("Token and Email cleared");
  }
}
