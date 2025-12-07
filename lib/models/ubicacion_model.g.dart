// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ubicacion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UbicacionModel _$UbicacionModelFromJson(Map<String, dynamic> json) =>
    UbicacionModel(
      id: (json['id'] as num).toInt(),
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      estaDentro: json['esta_dentro'] as bool,
      fechaHora: json['fecha_hora'] as String,
      idArea: (json['id_area'] as num).toInt(),
      idNino: (json['id_nino'] as num).toInt(),
    );

Map<String, dynamic> _$UbicacionModelToJson(UbicacionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'esta_dentro': instance.estaDentro,
      'fecha_hora': instance.fechaHora,
      'id_area': instance.idArea,
      'id_nino': instance.idNino,
    };

UbicacionCreateModel _$UbicacionCreateModelFromJson(
        Map<String, dynamic> json) =>
    UbicacionCreateModel(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      estaDentro: json['esta_dentro'] as bool,
      idArea: (json['id_area'] as num).toInt(),
      idNino: (json['id_nino'] as num).toInt(),
    );

Map<String, dynamic> _$UbicacionCreateModelToJson(
        UbicacionCreateModel instance) =>
    <String, dynamic>{
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'esta_dentro': instance.estaDentro,
      'id_area': instance.idArea,
      'id_nino': instance.idNino,
    };

UbicacionHistorialModel _$UbicacionHistorialModelFromJson(
        Map<String, dynamic> json) =>
    UbicacionHistorialModel(
      ubicaciones: (json['ubicaciones'] as List<dynamic>)
          .map((e) => UbicacionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      ninoId: (json['nino_id'] as num).toInt(),
      areaId: (json['area_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UbicacionHistorialModelToJson(
        UbicacionHistorialModel instance) =>
    <String, dynamic>{
      'ubicaciones': instance.ubicaciones,
      'total': instance.total,
      'nino_id': instance.ninoId,
      'area_id': instance.areaId,
    };
