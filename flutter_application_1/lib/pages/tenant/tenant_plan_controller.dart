import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/tenant/announcements/planned_tenant_announcements.dart';
import 'package:flutter_application_1/pages/tenant/home/planned_tenant_home.dart';
import 'package:flutter_application_1/pages/tenant/payments/planned_tenant_payments.dart';
import 'package:flutter_application_1/pages/tenant/planned_tenant_auth_service.dart';
import 'package:flutter_application_1/pages/tenant/profile/planned_tenant_profile.dart';
import 'package:flutter_application_1/pages/tenant/requests/planned_tenant_requests.dart';

class TenantPlanDashboardController extends GetxController {
  final PlannedTenantAuthService authService =
      Get.find<PlannedTenantAuthService>();

  RxString email = 'Loading...'.obs;
  RxInt selectedIndex = 0.obs;
  RxList<Widget> pages =
      <Widget>[].obs; // Fixed issue with pages initialization

  @override
  void onInit() {
    super.onInit();
    _loadTokenAndInitialize();
  }

  void _loadTokenAndInitialize() {
    if (authService.token.isNotEmpty) {
      email.value = authService.email.value;
    } else {
      email.value = 'Invalid token';
    }
    _initializePages();
  }

  void _initializePages() {
    pages.assignAll([
      PlannedTenantHome(),
      PlannedTenantPayments(),
      MaintenanceRequestPage(),
      PlannedTenantAnnouncements(),
      PlannedTenantProfile(),
    ]);
  }

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }

  Future<void> logout() async {
    await authService.clearToken();

    // Navigate back to login screen without requiring context
    Get.offAll(() => const LoginPage());
  }
}
