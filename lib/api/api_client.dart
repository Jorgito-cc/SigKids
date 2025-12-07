import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import '../config/local_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio _dio;
  final _storage = LocalStorage();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // ------------------------
    // INTERCEPTOR DE TOKEN
    // ------------------------
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            _storage.clearSession();
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Limpieza y mensajes humanos
  String handleError(DioException error) {
    if (error.response?.data is Map && error.response!.data['detail'] != null) {
      return error.response!.data['detail'].toString();
    }
    return 'Error inesperado. Intenta de nuevo.';
  }
}
