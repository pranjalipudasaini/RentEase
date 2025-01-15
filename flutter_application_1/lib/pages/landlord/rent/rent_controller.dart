import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RentController extends GetxController {
  var rents = <Map<String, dynamic>>[].obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    _loadRents();
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

  Future<void> _loadRents() async {
    try {
      var response = await http
          .get(Uri.parse('http://localhost:3000/rent/getRents'), headers: {
        'Authorization': 'Bearer ${token.value}',
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        rents.value = List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print("Error loading rents: $e");
    }
  }

  void addRent(Map<String, dynamic> rent) {
    rents.add(rent);
  }
}
