import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/landlord/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  final String email;

  const HomePage({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the landlord home page, $email!'),
    );
  }
}
