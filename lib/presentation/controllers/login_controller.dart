import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Campos login
  final email = TextEditingController();
  final password = TextEditingController();

  // Campos registro
  final name = TextEditingController();
  final lastname = TextEditingController();
  final ci = TextEditingController();
  final birth = TextEditingController();
  final address = TextEditingController();

  var obscure = true.obs;
  var loading = false.obs;
  var isRegister = false.obs;

  void toggleMode() => isRegister.value = !isRegister.value;

  void togglePassword() => obscure.value = !obscure.value;

  Future<void> pickBirthDate(BuildContext context) async {
    final p = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (p != null) {
      birth.text = "${p.day}/${p.month}/${p.year}";
    }
  }

  // LOGIN
  Future<void> login() async {
    loading.value = true;

    try {
      final token = await AuthApi.login(email.text, password.text);
      await LocalStorage().saveToken(token);

      Get.offAllNamed(AppRoutes.homeTutor);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }

  // REGISTRO
  Future<void> register() async {
    loading.value = true;

    try {
      await AuthApi.register({
        "email": email.text,
        "password": password.text,
      });

      Get.snackbar(
        "Éxito",
        "Cuenta creada correctamente",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      toggleMode();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }
}
