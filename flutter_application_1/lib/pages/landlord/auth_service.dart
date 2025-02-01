import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  var token = ''.obs;

  Future<AuthService> init() async {
    await _loadToken();
    return this;
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');

    print("Stored Token in SharedPreferences: $storedToken");

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
    } else {
      print("Error: Token is missing in SharedPreferences!");
    }
  }

  Future<void> saveToken(String newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    token.value = newToken;
    print("Token saved: $newToken"); // Debugging log
  }
}
