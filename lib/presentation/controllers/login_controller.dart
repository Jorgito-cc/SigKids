import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Modo login/registro
  var isRegister = false.obs;

  // Inputs
  final email = TextEditingController();
  final password = TextEditingController();

  final name = TextEditingController();
  final lastname = TextEditingController();
  final ci = TextEditingController();
  final birth = TextEditingController();
  final address = TextEditingController();

  // Estados
  var obscure = true.obs;
  var loading = false.obs;

  // Cambiar visibilidad password
  void togglePassword() => obscure.value = !obscure.value;

  // Cambiar entre login / registro
  void toggleMode() => isRegister.value = !isRegister.value;

  // Selector de fecha
  Future<void> pickBirthDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      birth.text = "${date.day}/${date.month}/${date.year}";
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
        "nombre": name.text,
        "apellido": lastname.text,
        "ci": ci.text,
        "direccion": address.text,
        "fechaNacimiento": birth.text,
      });

      Get.snackbar("Éxito", "Registro completado.",
          backgroundColor: Colors.green, colorText: Colors.white);

      toggleMode();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading.value = false;
    }
  }
}
