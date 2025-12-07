import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

class AuthApi {
  static final Dio _dio = ApiClient().dio;

  // -----------------------------
  // LOGIN
  // -----------------------------
  static Future<String> login(String email, String password) async {
    final data = FormData.fromMap({
      "username": email,
      "password": password,
    });

    try {
      final res = await _dio.post(
        '${AppConstants.authEndpoint}/jwt/login',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      return res.data["access_token"];
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // -----------------------------
  // REGISTRO
  // -----------------------------
  static Future<bool> register(Map<String, dynamic> data) async {
    try {
      await _dio.post('${AppConstants.authEndpoint}/register', data: data);
      return true;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // -----------------------------
  // USUARIO ACTUAL
  // -----------------------------
  static Future<Map<String, dynamic>> getMe() async {
    try {
      final res = await _dio.get('/users/me');
      return res.data;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // -----------------------------
  // VERIFICAR TOKEN
  // -----------------------------
  static Future<bool> verifyToken() async {
    try {
      await getMe();
      return true;
    } catch (_) {
      return false;
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  static Future<void> logout() async {
    try {
      await _dio.post('${AppConstants.authEndpoint}/jwt/logout');
    } catch (_) {}
  }
}
