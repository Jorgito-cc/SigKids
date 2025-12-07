import 'package:get/get.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';
import '../../api/auth_api.dart';

/// Controller para la pantalla de Splash
class SplashController extends GetxController {
  final LocalStorage _storage = LocalStorage();
  final AuthApi _authApi = AuthApi();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  /// Verificar autenticación y redirigir
  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // Animación de splash

    // Verificar si hay token guardado
    if (_storage.hasToken()) {
      // Verificar si el token es válido
      final isValid = await _authApi.verifyToken();

      if (isValid) {
        // Token válido, ir al home
        Get.offAllNamed(AppRoutes.home);
      } else {
        // Token inválido, limpiar y ir a login
        await _storage.clearSession();
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      // No hay token, ir a login
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
