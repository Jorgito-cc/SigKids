import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../api/tutor_api.dart';
import '../../config/local_storage.dart';
import '../../config/app_constants.dart';
import '../../models/tutor_model.dart';
import '../../routes/app_routes.dart';

/// Controller para Login y Registro
class LoginController extends GetxController {
  var isRegisterMode = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Campos extra solo para registro
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final ciController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final direccionController = TextEditingController();

  var obscurePassword = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ApiClient().initialize();
    // NADA MÁS AQUÍ
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleMode() {
    isRegisterMode.value = !isRegisterMode.value;
  }

  Future<void> login() async {
    // Aquí irá la API
  }

  Future<void> register() async {
    // Aquí irá la API
  }
}
