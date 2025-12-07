import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/login/login_page.dart';
import '../bindings/login_binding.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _showSplash();
  }

  Future<void> _showSplash() async {
    debugPrint('[SplashController] ✅ Mostrando splash por 800ms...');
    await Future.delayed(const Duration(milliseconds: 800));
    debugPrint('[SplashController] 🚀 Navegando a login...');
    Get.offAll(
      const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
