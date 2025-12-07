import 'package:dio/dio.dart';
import '../models/usuario_model.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// Servicio de autenticación
class AuthApi {
  final Dio _dio = ApiClient().dio;

  /// Registrar nuevo usuario
  Future<UsuarioModel> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConstants.authEndpoint}/register',
        data: {
          'email': email,
          'password': password,
        },
      );

      return UsuarioModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Iniciar sesión
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      // FastAPI-Users espera form data para login
      final formData = FormData.fromMap({
        'username': email, // FastAPI-Users usa 'username' para el email
        'password': password,
      });

      final response = await _dio.post(
        '${AppConstants.authEndpoint}/jwt/login',
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    try {
      await _dio.post('${AppConstants.authEndpoint}/jwt/logout');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener usuario actual
  Future<UsuarioModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return UsuarioModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Verificar si el token es válido
  Future<bool> verifyToken() async {
    try {
      await getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Solicitar restablecimiento de contraseña
  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(
        '${AppConstants.authEndpoint}/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Restablecer contraseña
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dio.post(
        '${AppConstants.authEndpoint}/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }
}
