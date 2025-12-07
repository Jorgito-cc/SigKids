import 'package:dio/dio.dart';
import '../models/ubicacion_model.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// Servicio API para gestión de ubicaciones
/// NOTA: Estos endpoints aún no existen en el backend, son preparatorios
class UbicacionApi {
  final Dio _dio = ApiClient().dio;

  /// Registrar una nueva ubicación
  Future<UbicacionModel> createUbicacion(UbicacionCreateModel ubicacion) async {
    try {
      final response = await _dio.post(
        AppConstants.ubicacionEndpoint,
        data: ubicacion.toJson(),
      );

      return UbicacionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener ubicación actual de un niño
  Future<UbicacionModel?> getUbicacionActual(int ninoId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.ubicacionEndpoint}/nino/$ninoId/actual',
      );

      if (response.data == null) return null;
      return UbicacionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener historial de ubicaciones de un niño
  Future<List<UbicacionModel>> getHistorialUbicaciones({
    required int ninoId,
    int? areaId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'nino_id': ninoId,
        'skip': skip,
        'limit': limit,
      };

      if (areaId != null) queryParams['area_id'] = areaId;
      if (fechaInicio != null) {
        queryParams['fecha_inicio'] = fechaInicio.toIso8601String();
      }
      if (fechaFin != null) {
        queryParams['fecha_fin'] = fechaFin.toIso8601String();
      }

      final response = await _dio.get(
        '${AppConstants.ubicacionEndpoint}/historial',
        queryParameters: queryParams,
      );

      return (response.data as List)
          .map((json) => UbicacionModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener estadísticas de ubicaciones
  Future<Map<String, dynamic>> getEstadisticas({
    required int ninoId,
    int? areaId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'nino_id': ninoId,
      };

      if (areaId != null) queryParams['area_id'] = areaId;
      if (fechaInicio != null) {
        queryParams['fecha_inicio'] = fechaInicio.toIso8601String();
      }
      if (fechaFin != null) {
        queryParams['fecha_fin'] = fechaFin.toIso8601String();
      }

      final response = await _dio.get(
        '${AppConstants.ubicacionEndpoint}/estadisticas',
        queryParameters: queryParams,
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener recorrido (polyline) de un niño
  Future<List<UbicacionModel>> getRecorrido({
    required int ninoId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.ubicacionEndpoint}/recorrido',
        queryParameters: {
          'nino_id': ninoId,
          'fecha_inicio': fechaInicio.toIso8601String(),
          'fecha_fin': fechaFin.toIso8601String(),
        },
      );

      return (response.data as List)
          .map((json) => UbicacionModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Eliminar ubicaciones antiguas
  Future<void> deleteUbicacionesAntiguas(DateTime fechaLimite) async {
    try {
      await _dio.delete(
        '${AppConstants.ubicacionEndpoint}/limpiar',
        data: {
          'fecha_limite': fechaLimite.toIso8601String(),
        },
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Verificar si un niño está dentro de un área (validación SIG)
  Future<bool> verificarDentroDeArea({
    required int ninoId,
    required int areaId,
    required double latitud,
    required double longitud,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConstants.ubicacionEndpoint}/verificar',
        data: {
          'nino_id': ninoId,
          'area_id': areaId,
          'latitud': latitud,
          'longitud': longitud,
        },
      );

      return response.data['esta_dentro'] ?? false;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }
}
