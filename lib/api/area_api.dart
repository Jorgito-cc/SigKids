import 'package:dio/dio.dart';
import '../models/area_model.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// Servicio API para gestión de áreas de monitoreo
/// NOTA: Estos endpoints aún no existen en el backend, son preparatorios
class AreaApi {
  final Dio _dio = ApiClient().dio;

  /// Obtener todas las áreas (con paginación)
  Future<List<AreaModel>> getAreas({int skip = 0, int limit = 100}) async {
    try {
      final response = await _dio.get(
        AppConstants.areaEndpoint,
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );

      return (response.data as List)
          .map((json) => AreaModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener áreas de un tutor específico
  Future<List<AreaModel>> getAreasByTutor(int tutorId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.areaEndpoint}/tutor/$tutorId',
      );

      return (response.data as List)
          .map((json) => AreaModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener un área por ID
  Future<AreaModel> getAreaById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.areaEndpoint}/$id');
      return AreaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Crear una nueva área
  Future<AreaModel> createArea(AreaCreateModel area) async {
    try {
      final response = await _dio.post(
        AppConstants.areaEndpoint,
        data: area.toJson(),
      );

      return AreaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Actualizar un área
  Future<AreaModel> updateArea(int id, AreaUpdateModel area) async {
    try {
      final response = await _dio.put(
        '${AppConstants.areaEndpoint}/$id',
        data: area.toJson(),
      );

      return AreaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Eliminar un área
  Future<void> deleteArea(int id) async {
    try {
      await _dio.delete('${AppConstants.areaEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Activar un área
  Future<AreaModel> activateArea(int id) async {
    try {
      final response = await _dio.patch(
        '${AppConstants.areaEndpoint}/$id/activate',
      );

      return AreaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Desactivar un área
  Future<AreaModel> deactivateArea(int id) async {
    try {
      final response = await _dio.patch(
        '${AppConstants.areaEndpoint}/$id/deactivate',
      );

      return AreaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Asignar niños a un área
  Future<void> assignNinosToArea(int areaId, List<int> ninoIds) async {
    try {
      await _dio.post(
        '${AppConstants.areaEndpoint}/$areaId/ninos',
        data: {'nino_ids': ninoIds},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener niños asignados a un área
  Future<List<int>> getNinosByArea(int areaId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.areaEndpoint}/$areaId/ninos',
      );

      return (response.data as List).cast<int>();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Remover niños de un área
  Future<void> removeNinosFromArea(int areaId, List<int> ninoIds) async {
    try {
      await _dio.delete(
        '${AppConstants.areaEndpoint}/$areaId/ninos',
        data: {'nino_ids': ninoIds},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }
}
