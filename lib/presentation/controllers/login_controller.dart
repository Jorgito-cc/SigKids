import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../api/api_client.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // --------------------------
  // FORM CONTROLLERS
  // --------------------------
  final email = TextEditingController();
  final password = TextEditingController();

  final name = TextEditingController();
  final lastname = TextEditingController();
  final ci = TextEditingController();
  final birth = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController(); // para hijo

  // --------------------------
  // ESTADOS
  // --------------------------
  var isRegister = false.obs;
  var isTutor = true.obs; // registro tutor o hijo
  var obscure = true.obs;
  var loading = false.obs;

  final _storage = LocalStorage();
  final dio.Dio _dio = ApiClient().dio;

  // --------------------------
  // CAMBIAR VISIBILIDAD PASS
  // --------------------------
  void togglePassword() => obscure.value = !obscure.value;

  // --------------------------
  // CAMBIAR ENTRE LOGIN / REGISTER
  // --------------------------
  void toggleMode() => isRegister.value = !isRegister.value;

  // --------------------------
  // SELECCIONAR ROL
  // --------------------------
  void selectRole(String role) {
    debugPrint('[LoginController] 📋 Rol seleccionado: $role');
    isTutor.value = (role == 'tutor');
    Get.toNamed('/register-form');
  }

  // --------------------------
  // FECHA DE NACIMIENTO
  // --------------------------
  Future<void> pickBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birth.text = picked.toIso8601String().split("T").first;
    }
  }

  // --------------------------
  // LOGIN
  // --------------------------
  Future<void> login() async {
    loading.value = true;

    try {
      final formData = dio.FormData.fromMap({
        "username": email.text,
        "password": password.text,
      });

      final resp = await _dio.post(
        "/auth/jwt/login",
        data: formData,
        options: dio.Options(contentType: "application/x-www-form-urlencoded"),
      );

      final token = resp.data["access_token"];
      await _storage.saveToken(token);

      // Obtener datos del usuario
      final userResp = await _dio.get("/users/me",
          options: dio.Options(headers: {"Authorization": "Bearer $token"}));

      final userId = userResp.data["id"];
      final userRole = userResp.data["role"] ?? "hijo"; // por defecto hijo
      final isTutorUser = userRole == "tutor";

      // Guardar rol y ID
      await _storage.saveUserId(userId);
      await _storage.saveUserRole(userRole);

      debugPrint('[LoginController] ✅ Login exitoso. Rol: $userRole');

      if (isTutorUser) {
        Get.offAllNamed(AppRoutes.homeTutor);
      } else {
        Get.offAllNamed(AppRoutes.homeHijo);
      }
    } catch (e) {
      Get.snackbar("Error", "Credenciales incorrectas");
    } finally {
      loading.value = false;
    }
  }

  // --------------------------
  // REGISTER (TUTOR O HIJO)
  // --------------------------
  Future<void> register() async {
    loading.value = true;

    try {
      // 1️⃣ Crear usuario
      final userResp = await _dio.post(
        "/auth/register",
        data: {
          "email": email.text,
          "password": password.text,
          "role": isTutor.value ? "tutor" : "hijo",
        },
      );

      final userId = userResp.data["id"];

      // 2️⃣ Guardar ID del usuario
      await _storage.saveUserId(userId);

      // 3️⃣ Crear entidad tutor o hijo
      if (isTutor.value) {
        await _crearTutor(userId);
        Get.snackbar("Éxito", "Tutor registrado correctamente");
        Get.offAllNamed(AppRoutes.homeTutor);
      } else {
        await _crearHijo(userId);
        Get.snackbar("Éxito", "Hijo registrado correctamente");
        Get.offAllNamed(AppRoutes.homeHijo);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "No se pudo registrar");
    } finally {
      loading.value = false;
    }
  }

  // --------------------------
  // CREAR TUTOR
  // --------------------------
  Future<void> _crearTutor(int userId) async {
    final token = _storage.getToken();

    await _dio.post(
      "/tutor/",
      data: {
        "nombre": name.text,
        "apellido": lastname.text,
        "ci": ci.text,
        "direccion": address.text,
        "fecha_nacimiento": birth.text,
        "rol": "tutor",
        "usuario_id": userId
      },
      options: dio.Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // --------------------------
  // CREAR HIJO
  // --------------------------
  Future<void> _crearHijo(int userId) async {
    final token = _storage.getToken();

    await _dio.post(
      "/hijo/",
      data: {
        "nombre": name.text,
        "apellido": lastname.text,
        "direccion": address.text,
        "fecha_nacimiento": birth.text,
        "telefono": phone.text,
        "usuario_id": userId,
      },
      options: dio.Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
