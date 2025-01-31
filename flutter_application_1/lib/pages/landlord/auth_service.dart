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
    if (storedToken == null || storedToken.isEmpty) {
      print("Error: Token is missing!");
    } else {
      print("Loaded token: $storedToken");
      token.value = storedToken;
    }
  }
}
