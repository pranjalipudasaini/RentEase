import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/profile/profile_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Profile Page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
