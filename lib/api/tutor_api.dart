import 'package:dio/dio.dart';
import '../models/tutor_model.dart';
import '../config/app_constants.dart';
import 'api_client.dart';

/// Servicio API para gestión de tutores
class TutorApi {
  final Dio _dio = ApiClient().dio;

  /// Obtener todos los tutores (con paginación)
  Future<List<TutorModel>> getTutores({int skip = 0, int limit = 100}) async {
    try {
      final response = await _dio.get(
        AppConstants.tutorEndpoint,
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );

      return (response.data as List)
          .map((json) => TutorModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener un tutor por ID
  Future<TutorModel> getTutorById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.tutorEndpoint}/$id');
      return TutorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Crear un nuevo tutor
  Future<TutorModel> createTutor(TutorCreateModel tutor) async {
    try {
      final response = await _dio.post(
        AppConstants.tutorEndpoint,
        data: tutor.toJson(),
      );

      return TutorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Actualizar un tutor
  Future<TutorModel> updateTutor(int id, TutorUpdateModel tutor) async {
    try {
      final response = await _dio.put(
        '${AppConstants.tutorEndpoint}/$id',
        data: tutor.toJson(),
      );

      return TutorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Eliminar un tutor
  Future<void> deleteTutor(int id) async {
    try {
      await _dio.delete('${AppConstants.tutorEndpoint}/$id');
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Obtener tutor con sus hijos
  Future<Map<String, dynamic>> getTutorWithHijos(int tutorId) async {
    try {
      final response =
          await _dio.get('${AppConstants.tutorEndpoint}/$tutorId/hijos');
      return response.data;
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Asignar un hijo a un tutor
  Future<void> assignHijoToTutor(int tutorId, String hijoEmail) async {
    try {
      await _dio.post(
        '${AppConstants.tutorEndpoint}/$tutorId/hijos',
        data: {'hijo_email': hijoEmail},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  /// Remover un hijo de un tutor
  Future<void> removeHijoFromTutor(int tutorId, int hijoId) async {
    try {
      await _dio.delete(
        '${AppConstants.tutorEndpoint}/$tutorId/hijos',
        data: {'hijo_id': hijoId},
      );
    } on DioException catch (e) {
      throw ApiClient().handleError(e);
    }
  }

  // Obtener tutor con hijos
  static Future<TutorModel> getTutor(int tutorId) async {
    final dio = ApiClient().dio;
    final res = await dio.get("/tutor/$tutorId/hijos");
    return TutorModel.fromJson(res.data);
  }

  // Agregar hijo al tutor por email
  static Future<TutorModel> addHijo(int tutorId, String email) async {
    final dio = ApiClient().dio;
    final res = await dio.post("/tutor/$tutorId/hijos", data: {
      "hijo_email": email,
    });
    return TutorModel.fromJson(res.data);
  }

  // Eliminar un hijo del tutor
  static Future<TutorModel> removeHijo(int tutorId, int hijoId) async {
    final dio = ApiClient().dio;
    final res = await dio.delete("/tutor/$tutorId/hijos", data: {
      "hijo_id": hijoId,
    });
    return TutorModel.fromJson(res.data);
  }
}
