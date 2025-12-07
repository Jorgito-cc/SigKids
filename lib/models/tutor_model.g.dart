// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorModel _$TutorModelFromJson(Map<String, dynamic> json) => TutorModel(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      rol: json['rol'] as String,
      fechaNacimiento: json['fecha_nacimiento'] as String,
      ci: json['ci'] as String,
      direccion: json['direccion'] as String,
      createdAt: json['created_at'] as String,
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TutorModelToJson(TutorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'rol': instance.rol,
      'fecha_nacimiento': instance.fechaNacimiento,
      'ci': instance.ci,
      'direccion': instance.direccion,
      'created_at': instance.createdAt,
      'usuario': instance.usuario,
    };

TutorCreateModel _$TutorCreateModelFromJson(Map<String, dynamic> json) =>
    TutorCreateModel(
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      rol: json['rol'] as String,
      fechaNacimiento: json['fecha_nacimiento'] as String,
      ci: json['ci'] as String,
      direccion: json['direccion'] as String,
      usuarioId: (json['usuario_id'] as num).toInt(),
    );

Map<String, dynamic> _$TutorCreateModelToJson(TutorCreateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'rol': instance.rol,
      'fecha_nacimiento': instance.fechaNacimiento,
      'ci': instance.ci,
      'direccion': instance.direccion,
      'usuario_id': instance.usuarioId,
    };

TutorUpdateModel _$TutorUpdateModelFromJson(Map<String, dynamic> json) =>
    TutorUpdateModel(
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      rol: json['rol'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      ci: json['ci'] as String?,
      direccion: json['direccion'] as String?,
    );

Map<String, dynamic> _$TutorUpdateModelToJson(TutorUpdateModel instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'rol': instance.rol,
      'fecha_nacimiento': instance.fechaNacimiento,
      'ci': instance.ci,
      'direccion': instance.direccion,
    };
