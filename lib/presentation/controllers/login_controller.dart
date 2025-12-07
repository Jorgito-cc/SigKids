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
  final AuthApi _authApi = AuthApi();
  final TutorApi _tutorApi = TutorApi();
  final LocalStorage _storage = LocalStorage();

  // Controllers de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final ciController = TextEditingController();
  final direccionController = TextEditingController();
  final fechaNacimientoController = TextEditingController();

  // Estados observables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final isRegisterMode = false.obs;

  DateTime? selectedFechaNacimiento;

  @override
  void onInit() {
    super.onInit();
    debugPrint(
        '[LoginController] ✅ LoginController inicializado correctamente');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    ciController.dispose();
    direccionController.dispose();
    fechaNacimientoController.dispose();
    super.onClose();
  }

  /// Toggle visibilidad de contraseña
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Cambiar entre modo login y registro
  void toggleMode() {
    isRegisterMode.value = !isRegisterMode.value;
  }

  /// Login
  Future<void> login() async {
    if (!_validateLoginForm()) return;

    try {
      isLoading.value = true;

      // 1. Login y obtener token
      final loginResponse = await _authApi.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // 2. Guardar token
      await _storage.saveToken(loginResponse.accessToken);

      // 3. Obtener datos del usuario
      final user = await _authApi.getCurrentUser();
      await _storage.saveUser(user.toJson());

      // 4. Detectar tipo de usuario (tutor o hijo)
      String tipoUsuario = 'desconocido';

      // Intentar obtener datos del tutor
      try {
        final tutores = await _tutorApi.getTutores(limit: 1000);
        final tutor = tutores.firstWhereOrNull(
          (t) => t.usuario.id == user.id,
        );

        if (tutor != null) {
          tipoUsuario = 'tutor';
          await _storage.saveTutor(tutor.toJson());
          await _storage.saveTipoUsuario(tipoUsuario);
        }
      } catch (e) {
        // No es tutor, intentar obtener datos del hijo
      }

      // Si no es tutor, intentar obtener datos del hijo
      if (tipoUsuario == 'desconocido') {
        try {
          // TODO: Implementar cuando HijoApi esté completo
          // final hijos = await _hijoApi.getHijos(limit: 1000);
          // final hijo = hijos.firstWhereOrNull((h) => h.usuario.id == user.id);
          // if (hijo != null) {
          //   tipoUsuario = 'hijo';
          //   await _storage.saveHijo(hijo.toJson());
          //   await _storage.saveTipoUsuario(tipoUsuario);
          // }
        } catch (e) {
          // No es hijo
        }
      }

      // 5. Redirigir según tipo de usuario
      if (tipoUsuario == 'tutor') {
        Get.offAllNamed(AppRoutes.homeTutor);
        Get.snackbar(
          '¡Bienvenido Tutor!',
          'Has iniciado sesión correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (tipoUsuario == 'hijo') {
        Get.offAllNamed(AppRoutes.homeHijo);
        Get.snackbar(
          '¡Bienvenido!',
          'Has iniciado sesión correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        // Usuario sin perfil de tutor ni hijo
        await _storage.clearSession();
        Get.snackbar(
          'Error',
          'No se encontró un perfil asociado a tu cuenta',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error de autenticación',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Registro
  Future<void> register() async {
    if (!_validateRegisterForm()) return;

    try {
      isLoading.value = true;

      // 1. Registrar usuario
      final user = await _authApi.register(
        emailController.text.trim(),
        passwordController.text,
      );

      // 2. Login automático para obtener token
      final loginResponse = await _authApi.login(
        emailController.text.trim(),
        passwordController.text,
      );

      await _storage.saveToken(loginResponse.accessToken);
      await _storage.saveUser(user.toJson());

      // 3. Crear perfil de tutor
      final tutorCreate = TutorCreateModel(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        rol: 'TUTOR',
        fechaNacimiento: _formatDate(selectedFechaNacimiento!),
        ci: ciController.text.trim(),
        direccion: direccionController.text.trim(),
        usuarioId: user.id,
      );

      final tutor = await _tutorApi.createTutor(tutorCreate);
      await _storage.saveTutor(tutor.toJson());

      Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        '¡Registro exitoso!',
        'Tu cuenta ha sido creada correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error en el registro',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Seleccionar fecha de nacimiento
  Future<void> selectFechaNacimiento(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      selectedFechaNacimiento = picked;
      fechaNacimientoController.text = _formatDateDisplay(picked);
    }
  }

  /// Validar formulario de login
  bool _validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Ingresa tu email');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Ingresa un email válido');
      return false;
    }

    if (passwordController.text.length < AppConstants.minPasswordLength) {
      Get.snackbar(
        'Error',
        'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres',
      );
      return false;
    }

    return true;
  }

  /// Validar formulario de registro
  bool _validateRegisterForm() {
    if (nombreController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Ingresa tu nombre');
      return false;
    }

    if (apellidoController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Ingresa tu apellido');
      return false;
    }

    if (ciController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Ingresa tu cédula de identidad');
      return false;
    }

    if (selectedFechaNacimiento == null) {
      Get.snackbar('Error', 'Selecciona tu fecha de nacimiento');
      return false;
    }

    if (direccionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Ingresa tu dirección');
      return false;
    }

    return _validateLoginForm();
  }

  /// Formatear fecha para API (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Formatear fecha para mostrar
  String _formatDateDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
