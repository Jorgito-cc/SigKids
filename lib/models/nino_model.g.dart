// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nino_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NinoModel _$NinoModelFromJson(Map<String, dynamic> json) => NinoModel(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      fechaNacimiento: json['fecha_nacimiento'] as String,
      telefono: json['telefono'] as String,
      direccion: json['direccion'] as String,
      createdAt: json['created_at'] as String,
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NinoModelToJson(NinoModel instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'fecha_nacimiento': instance.fechaNacimiento,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
      'created_at': instance.createdAt,
      'usuario': instance.usuario,
    };

NinoCreateModel _$NinoCreateModelFromJson(Map<String, dynamic> json) =>
    NinoCreateModel(
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      fechaNacimiento: json['fecha_nacimiento'] as String,
      telefono: json['telefono'] as String,
      direccion: json['direccion'] as String,
      usuarioId: (json['usuario_id'] as num).toInt(),
    );

Map<String, dynamic> _$NinoCreateModelToJson(NinoCreateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'fecha_nacimiento': instance.fechaNacimiento,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
      'usuario_id': instance.usuarioId,
    };

NinoUpdateModel _$NinoUpdateModelFromJson(Map<String, dynamic> json) =>
    NinoUpdateModel(
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
    );

Map<String, dynamic> _$NinoUpdateModelToJson(NinoUpdateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'fecha_nacimiento': instance.fechaNacimiento,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
    };
