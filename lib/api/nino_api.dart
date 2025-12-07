import 'package:dio/dio.dart';
import '../models/nino_model.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// Servicio API para gestión de niños (hijos)
class NinoApi {
  final Dio _dio = ApiClient().dio;

  /// Obtener todos los niños (con paginación)
  Future<List<NinoModel>> getNinos({int skip = 0, int limit = 100}) async {
    try {
      final response = await _dio.get(
        AppConstants.hijoEndpoint,
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );

      return (response.data as List)
          .map((json) => NinoModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener un niño por ID
  Future<NinoModel> getNinoById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.hijoEndpoint}/$id');
      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Crear un nuevo niño
  Future<NinoModel> createNino(NinoCreateModel nino) async {
    try {
      final response = await _dio.post(
        AppConstants.hijoEndpoint,
        data: nino.toJson(),
      );

      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Actualizar un niño
  Future<NinoModel> updateNino(int id, NinoUpdateModel nino) async {
    try {
      final response = await _dio.put(
        '${AppConstants.hijoEndpoint}/$id',
        data: nino.toJson(),
      );

      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Eliminar un niño
  Future<void> deleteNino(int id) async {
    try {
      await _dio.delete('${AppConstants.hijoEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener niños de un tutor específico
  Future<List<NinoModel>> getNinosByTutor(int tutorId) async {
    try {
      final response =
          await _dio.get('${AppConstants.tutorEndpoint}/$tutorId/hijos');

      // El backend devuelve un objeto con la lista de hijos
      final hijos = response.data['hijos'] as List;
      return hijos.map((json) => NinoModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Asignar un tutor a un niño
  Future<void> assignTutorToNino(int ninoId, String tutorEmail) async {
    try {
      await _dio.post(
        '${AppConstants.hijoEndpoint}/$ninoId/tutores',
        data: {'tutor_email': tutorEmail},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Remover un tutor de un niño
  Future<void> removeTutorFromNino(int ninoId, int tutorId) async {
    try {
      await _dio.delete(
        '${AppConstants.hijoEndpoint}/$ninoId/tutores',
        data: {'tutor_id': tutorId},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }
}
