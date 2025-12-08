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
  final phone = TextEditingController(); // hijo

  // --------------------------
  // ESTADOS
  // --------------------------
  var isRegister = false.obs;
  var isTutor = true.obs;
  var obscure = true.obs;
  var loading = false.obs;

  final _storage = LocalStorage();
  final dio.Dio _dio = ApiClient().dio;
// ======== GETTERS PÚBLICOS ========
  // 🔓 GETTERS PÚBLICOS PARA ACCESO DESDE OTRAS PÁGINAS
  dio.Dio get dioClient => _dio;

  LocalStorage get storage => _storage;

  Future<String?> get token async => _storage.getToken();

  Future<int?> get userId async => _storage.getUserId();

  dio.Options authHeader() {
    return dio.Options(headers: {"Authorization": "Bearer $token"});
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint("🔥 LoginController INICIALIZADO → hash: ${this.hashCode}");
  }

  // --------------------------
  // CAMBIAR VISIBILIDAD PASS
  // --------------------------
  void togglePassword() {
    obscure.value = !obscure.value;
    debugPrint("🔐 Cambiar visibilidad password → ${obscure.value}");
  }

  // --------------------------
  // SELECCIÓN DE ROL
  // --------------------------
  void selectRole(String role) {
    debugPrint("====================================");
    debugPrint("🎭 SELECCIÓN DE ROL");
    debugPrint("➡ Rol seleccionado: $role");
    debugPrint("====================================");

    isTutor.value = (role == "tutor");
    isRegister.value = true;

    if (isTutor.value) {
      debugPrint("➡ Navegando a registro TUTOR...");
      Get.toNamed(AppRoutes.registerTutor);
    } else {
      debugPrint("➡ Navegando a registro HIJO...");
      Get.toNamed(AppRoutes.registerHijo);
    }
  }

  // --------------------------
  // FECHA DE NACIMIENTO
  // --------------------------
  Future<void> pickBirthDate(BuildContext context) async {
    debugPrint("📅 Abriendo selector de fecha…");

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birth.text = picked.toIso8601String().split("T").first;
      debugPrint("📅 Fecha seleccionada: ${birth.text}");
    } else {
      debugPrint("⚠ Selección de fecha cancelada");
    }
  }

  // --------------------------
  // LOGIN
  // --------------------------
  Future<void> login() async {
    loading.value = true;

    debugPrint("====================================");
    debugPrint("🔵 INICIANDO LOGIN");
    debugPrint("📧 Email: ${email.text}");
    debugPrint("🔑 Password ingresada");
    debugPrint("====================================");

    try {
      // 1️⃣ Solicitar token
      debugPrint("📤 [1] Enviando login a /auth/jwt/login...");

      final formData = dio.FormData.fromMap({
        "username": email.text,
        "password": password.text,
      });

      debugPrint("📦 Payload enviado: ${formData.fields}");

      final resp = await _dio.post(
        "/auth/jwt/login",
        data: formData,
        options: dio.Options(contentType: "application/x-www-form-urlencoded"),
      );

      debugPrint("📥 [1] Respuesta login: ${resp.data}");

      final token = resp.data["access_token"];
      await _storage.saveToken(token);

      debugPrint("🔐 TOKEN GUARDADO: $token");

      // 2️⃣ Obtener datos del usuario
      debugPrint("------------------------------------");
      debugPrint("📤 [2] Solicitando datos con /users/me...");
      debugPrint("------------------------------------");

      final userResp = await _dio.get(
        "/users/me",
        options: dio.Options(headers: {"Authorization": "Bearer $token"}),
      );

      debugPrint("📥 Datos usuario: ${userResp.data}");

      final user = userResp.data;
      final userId = user["id"];
      final rol = user["rol"] ?? "hijo";

      await _storage.saveUserId(userId);
      await _storage.saveUserRole(rol);

      debugPrint("👤 Usuario ID: $userId");
      debugPrint("🎭 Rol detectado: $rol");

      // 3️⃣ Obtener perfil según rol
      debugPrint("====================================");
      debugPrint("📂 CARGANDO PERFIL SEGÚN ROL...");
      debugPrint("====================================");

      if (rol == "tutor") {
        debugPrint("📤 Buscando perfil de TUTOR en /tutor/by_user/$userId");

        final tutorResp = await _dio.get(
          "/tutor/user/$userId",
          options: dio.Options(headers: {"Authorization": "Bearer $token"}),
        );

        final t = tutorResp.data;
        debugPrint("📥 Perfil tutor recibido: $t");
        print("💾 Guardando perfil del tutor en LocalStorage...");
        _storage.saveTutor(t);
        print("✅ Tutor guardado correctamente en LocalStorage");

        name.text = t["nombre"] ?? "";
        lastname.text = t["apellido"] ?? "";
        ci.text = t["ci"] ?? "";
        birth.text = t["fecha_nacimiento"] ?? "";
        address.text = t["direccion"] ?? "";
        phone.text = "";

        debugPrint("✅ Perfil tutor asignado al controlador");
      } else if (rol == "hijo") {
        debugPrint("📤 Buscando perfil de HIJO en /hijo/by_user/$userId");

        final hijoResp = await _dio.get(
          "/hijo/user/$userId",
          options: dio.Options(headers: {"Authorization": "Bearer $token"}),
        );

        final h = hijoResp.data;
        debugPrint("📥 Perfil hijo recibido: $h");
        name.text = h["nombre"] ?? "";
        lastname.text = h["apellido"] ?? "";
        address.text = h["direccion"] ?? "";
        birth.text = h["fecha_nacimiento"] ?? "";
        phone.text = h["telefono"] ?? "";

        update(); // 👈 importante

        debugPrint("✅ Perfil hijo asignado al controlador");
      }

      // 4️⃣ Redirigir
      debugPrint("====================================");
      debugPrint("➡ REDIRECCIÓN SEGÚN ROL");
      debugPrint("====================================");

      if (rol == "tutor") {
        debugPrint("➡ Navegando a: homeTutor");
        Get.offAllNamed(AppRoutes.homeTutor);
      } else {
        debugPrint("➡ Navegando a: homeHijo");
        Get.offAllNamed(AppRoutes.homeHijo);
      }
    } catch (e) {
      debugPrint("❌ ERROR EN LOGIN: $e");
      Get.snackbar("Error", "Credenciales incorrectas");
    } finally {
      loading.value = false;
    }
  }

  // --------------------------
  // LOGOUT
  // --------------------------
  Future<void> logout() async {
    debugPrint("====================================");
    debugPrint("🚪 CERRANDO SESIÓN");
    debugPrint("====================================");

    await _storage.clearSession();

    email.clear();
    password.clear();
    name.clear();
    lastname.clear();
    ci.clear();
    birth.clear();
    address.clear();
    phone.clear();

    debugPrint("🧹 Datos limpiados de memoria");
  }

  // --------------------------
  // REGISTRO
  // --------------------------
  Future<void> register() async {
    loading.value = true;

    final rol = isTutor.value ? "tutor" : "hijo";

    debugPrint("====================================");
    debugPrint("🟢 INICIANDO REGISTRO");
    debugPrint("📧 Email: ${email.text}");
    debugPrint("🔑 Password: ${password.text}");
    debugPrint("🎭 Rol: $rol");
    debugPrint("====================================");

    try {
      debugPrint("📤 Creando USUARIO en /auth/register...");

      final userResp = await _dio.post(
        "/auth/register",
        data: {
          "email": email.text,
          "password": password.text,
          "rol": rol,
        },
      );

      debugPrint("📥 Usuario creado: ${userResp.data}");

      final userId = userResp.data["id"];
      await _storage.saveUserId(userId);
      await _storage.saveUserRole(rol);

      debugPrint("👤 Usuario ID guardado: $userId");

      if (isTutor.value) {
        debugPrint("🟦 Registrando PERFIL TUTOR...");
        await _crearTutor(userId);
        debugPrint("✅ Tutor creado correctamente");
        Get.offAllNamed(AppRoutes.homeTutor);
      } else {
        debugPrint("🟪 Registrando PERFIL HIJO...");
        await _crearHijo(userId);
        debugPrint("✅ Hijo creado correctamente");
        Get.offAllNamed(AppRoutes.homeHijo);
      }
    } catch (e) {
      debugPrint("❌ ERROR EN REGISTRO: $e");
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

    debugPrint("📤 Enviando datos TUTOR a /tutor/");
    debugPrint("📦 Payload tutor:");
    debugPrint("   → nombre: ${name.text}");
    debugPrint("   → apellido: ${lastname.text}");
    debugPrint("   → ci: ${ci.text}");
    debugPrint("   → direccion: ${address.text}");
    debugPrint("   → fecha_nacimiento: ${birth.text}");
    debugPrint("   → usuario_id: $userId");

    final resp = await _dio.post(
      "/tutor/",
      data: {
        "nombre": name.text,
        "apellido": lastname.text,
        "ci": ci.text,
        "direccion": address.text,
        "fecha_nacimiento": birth.text,
        "usuario_id": userId,
      },
      options: dio.Options(headers: {"Authorization": "Bearer $token"}),
    );

    debugPrint("📥 Respuesta crear tutor: ${resp.data}");
  }

  // --------------------------
  // CREAR HIJO
  // --------------------------
  Future<void> _crearHijo(int userId) async {
    final token = _storage.getToken();

    debugPrint("📤 Enviando datos HIJO a /hijo/");
    debugPrint("📦 Payload hijo:");
    debugPrint("   → nombre: ${name.text}");
    debugPrint("   → apellido: ${lastname.text}");
    debugPrint("   → direccion: ${address.text}");
    debugPrint("   → fecha_nacimiento: ${birth.text}");
    debugPrint("   → telefono: ${phone.text}");
    debugPrint("   → usuario_id: $userId");

    final resp = await _dio.post(
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

    debugPrint("📥 Respuesta crear hijo: ${resp.data}");
  }
}
