import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import '../config/local_storage.dart';

/// Cliente HTTP configurado con Dio para consumir la API
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final LocalStorage _storage = LocalStorage();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout:
            const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para agregar token de autenticación
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🌐 REQUEST[${options.method}] => ${options.path}');
          print('📦 DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print(
              '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          print('📛 MESSAGE: ${error.message}');
          print('📛 DATA: ${error.response?.data}');

          // Si el error es 401 (no autorizado), limpiar sesión
          if (error.response?.statusCode == 401) {
            _storage.clearSession();
          }

          return handler.next(error);
        },
      ),
    );

    // Interceptor para logging (opcional, solo en desarrollo)
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  /// Manejo de errores HTTP
  String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado. Verifica tu internet.';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado. Intenta nuevamente.';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de recepción agotado. El servidor no responde.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return 'Solicitud cancelada.';
      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica tu internet.';
      default:
        return 'Error inesperado: ${error.message}';
    }
  }

  String _handleBadResponse(Response? response) {
    if (response == null) return 'Error desconocido del servidor.';

    switch (response.statusCode) {
      case 400:
        // Intentar extraer mensaje de error del backend
        if (response.data is Map && response.data['detail'] != null) {
          return 'Error: ${response.data['detail']}';
        }
        return 'Solicitud incorrecta. Verifica los datos enviados.';
      case 401:
        return 'No autorizado. Inicia sesión nuevamente.';
      case 403:
        return 'Acceso prohibido. No tienes permisos.';
      case 404:
        return 'Recurso no encontrado.';
      case 422:
        // Errores de validación de FastAPI
        if (response.data is Map && response.data['detail'] != null) {
          final detail = response.data['detail'];
          if (detail is List && detail.isNotEmpty) {
            final firstError = detail[0];
            return 'Error de validación: ${firstError['msg'] ?? 'Datos inválidos'}';
          }
          return 'Error de validación: $detail';
        }
        return 'Datos de entrada inválidos.';
      case 500:
        return 'Error interno del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio no disponible. Intenta más tarde.';
      default:
        return 'Error del servidor (${response.statusCode}).';
    }
  }
}
