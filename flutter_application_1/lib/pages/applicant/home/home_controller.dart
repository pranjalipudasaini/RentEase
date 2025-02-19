import 'package:flutter_application_1/pages/landlord/auth_service.dart';
import 'package:get/get.dart';

class ApplicantHomeController extends GetxController {
  late final RxString token;

  @override
  void onInit() {
    super.onInit();

    final authService = Get.find<AuthService>();
    token = authService.token;
  }
}
