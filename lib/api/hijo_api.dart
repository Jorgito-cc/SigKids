import 'package:dio/dio.dart';
import '../models/nino_model.dart'; // TODO: Renombrar a hijo_model.dart
import 'api_client.dart';

/// Servicio API para gestión de hijos
class HijoApi {
  final Dio _dio = ApiClient().dio;

  /// Obtener todos los hijos (con paginación)
  Future<List<NinoModel>> getHijos({int skip = 0, int limit = 100}) async {
    try {
      final response = await _dio.get(
        '/hijo/',
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

  /// Obtener un hijo por ID
  Future<NinoModel> getHijoById(int id) async {
    try {
      final response = await _dio.get('/hijo/$id');
      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Crear un nuevo hijo
  Future<NinoModel> createHijo(NinoCreateModel hijo) async {
    try {
      final response = await _dio.post(
        '/hijo/',
        data: hijo.toJson(),
      );

      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Actualizar un hijo
  Future<NinoModel> updateHijo(int id, NinoUpdateModel hijo) async {
    try {
      final response = await _dio.put(
        '/hijo/$id',
        data: hijo.toJson(),
      );

      return NinoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Eliminar un hijo
  Future<void> deleteHijo(int id) async {
    try {
      await _dio.delete('/hijo/$id');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener hijo con sus tutores
  Future<Map<String, dynamic>> getHijoWithTutores(int hijoId) async {
    try {
      final response = await _dio.get('/hijo/$hijoId/tutores');
      return response.data;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Asignar un tutor a un hijo
  Future<void> assignTutorToHijo(int hijoId, String tutorEmail) async {
    try {
      await _dio.post(
        '/hijo/$hijoId/tutores',
        data: {'tutor_email': tutorEmail},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Remover un tutor de un hijo
  Future<void> removeTutorFromHijo(int hijoId, int tutorId) async {
    try {
      await _dio.delete(
        '/hijo/$hijoId/tutores',
        data: {'tutor_id': tutorId},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }




  
}
