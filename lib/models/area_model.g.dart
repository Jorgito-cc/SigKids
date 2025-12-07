// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaModel _$AreaModelFromJson(Map<String, dynamic> json) => AreaModel(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      vertices: (json['vertices'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      estado: json['estado'] as String,
      idTutorCreador: (json['id_tutor_creador'] as num).toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$AreaModelToJson(AreaModel instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'vertices': instance.vertices,
      'estado': instance.estado,
      'id_tutor_creador': instance.idTutorCreador,
      'created_at': instance.createdAt,
    };

AreaCreateModel _$AreaCreateModelFromJson(Map<String, dynamic> json) =>
    AreaCreateModel(
      nombre: json['nombre'] as String,
      vertices: (json['vertices'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      estado: json['estado'] as String? ?? 'ACTIVO',
      idTutorCreador: (json['id_tutor_creador'] as num).toInt(),
    );

Map<String, dynamic> _$AreaCreateModelToJson(AreaCreateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'vertices': instance.vertices,
      'estado': instance.estado,
      'id_tutor_creador': instance.idTutorCreador,
    };

AreaUpdateModel _$AreaUpdateModelFromJson(Map<String, dynamic> json) =>
    AreaUpdateModel(
      nombre: json['nombre'] as String?,
      vertices: (json['vertices'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$AreaUpdateModelToJson(AreaUpdateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'vertices': instance.vertices,
      'estado': instance.estado,
    };

AreaAsignacionModel _$AreaAsignacionModelFromJson(Map<String, dynamic> json) =>
    AreaAsignacionModel(
      areaId: (json['area_id'] as num).toInt(),
      ninoIds: (json['nino_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AreaAsignacionModelToJson(
        AreaAsignacionModel instance) =>
    <String, dynamic>{
      'area_id': instance.areaId,
      'nino_ids': instance.ninoIds,
    };
