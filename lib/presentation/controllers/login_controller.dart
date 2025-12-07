import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  var isLoading = false.obs;
  var isRegister = false.obs;

  final name = TextEditingController();
  final lastname = TextEditingController();
  final ci = TextEditingController();
  final birth = TextEditingController();
  final address = TextEditingController();

  void toggleMode() => isRegister.value = !isRegister.value;

  Future<void> login() async {
    isLoading.value = true;

    try {
      final token = await AuthApi.login(email.text, password.text);
      await LocalStorage().saveToken(token);

      Get.offAllNamed(AppRoutes.homeTutor);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    isLoading.value = true;

    try {
      await AuthApi.register({
        "email": email.text,
        "password": password.text,
      });

      Get.snackbar("Éxito", "Tu cuenta fue creada.",
          backgroundColor: Colors.green, colorText: Colors.white);

      toggleMode();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
