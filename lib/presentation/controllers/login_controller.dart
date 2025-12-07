import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  var isRegisterMode = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Campos de registro
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final ciController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final direccionController = TextEditingController();

  var obscurePassword = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleMode() {
    isRegisterMode.value = !isRegisterMode.value;
  }

  Future<void> selectFechaNacimiento(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) {
      fechaNacimientoController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  // ------------------------------------------
  // LOGIN
  // ------------------------------------------
  Future<void> login() async {
    isLoading.value = true;

    try {
      final token = await AuthApi.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (token == null) throw Exception("Token vacío");

      // Guardar token en Storage
      await LocalStorage().saveToken(token);

      // Ir al Home
      Get.offAllNamed(AppRoutes.homeTutor);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Credenciales inválidas",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------
  // REGISTRO
  // ------------------------------------------
  Future<void> register() async {
    isLoading.value = true;

    try {
      final ok = await AuthApi.register({
        "nombre": nombreController.text,
        "apellido": apellidoController.text,
        "ci": ciController.text,
        "fechaNacimiento": fechaNacimientoController.text,
        "direccion": direccionController.text,
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });

      if (!ok) throw Exception("Registro fallido");

      Get.snackbar(
        "Éxito",
        "Cuenta creada correctamente",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      toggleMode(); // Volver a login
    } catch (e) {
      Get.snackbar(
        "Error",
        "No se pudo registrar",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
