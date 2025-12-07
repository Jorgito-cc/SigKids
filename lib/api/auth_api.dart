import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// MODELO DE RESPUESTA LOGIN (TOKEN)
class LoginResponseModel {
  final String accessToken;
  final String tokenType;

  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}

/// Servicio de autenticación
class AuthApi {
  static final Dio _dio = ApiClient().dio;

  // ----------------------------------------
  // REGISTRO
  // ----------------------------------------
  static Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '${AppConstants.authEndpoint}/register',
        data: data,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // ----------------------------------------
  // LOGIN
  // ----------------------------------------
  static Future<String?> login(String email, String password) async {
    try {
      final formData = FormData.fromMap({
        "username": email,
        "password": password,
      });

      final response = await _dio.post(
        '${AppConstants.authEndpoint}/jwt/login',
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final loginData = LoginResponseModel.fromJson(response.data);

      return loginData.accessToken;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // ----------------------------------------
  // LOGOUT
  // ----------------------------------------
  static Future<void> logout() async {
    try {
      await _dio.post('${AppConstants.authEndpoint}/jwt/logout');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // ----------------------------------------
  // USUARIO ACTUAL
  // ----------------------------------------
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return response.data;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // ----------------------------------------
  // VERIFICAR TOKEN
  // ----------------------------------------
  static Future<bool> verifyToken() async {
    try {
      await getCurrentUser();
      return true;
    } catch (_) {
      return false;
    }
  }
}
