import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantAuthService extends GetxService {
  RxString token = ''.obs;
  var email = ''.obs;

  Future<TenantAuthService> init() async {
    await _loadToken();
    return this;
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');
    String? storedEmail = prefs.getString('email'); // Ensure email is stored

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
    }

    if (storedEmail != null && storedEmail.isNotEmpty) {
      email.value = storedEmail; // Store email correctly
    }

    print("Stored Token: $storedToken, Stored Email: $storedEmail");
  }

  Future<void> saveToken(String newToken, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    await prefs.setString('email', userEmail);
    token.value = newToken;
    email.value = userEmail;

    print("Token saved in SharedPreferences: $newToken");
    print("Email saved in SharedPreferences: $userEmail");
  }
}
