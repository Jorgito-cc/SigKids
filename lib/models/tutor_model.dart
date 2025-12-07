import 'package:json_annotation/json_annotation.dart';
import 'usuario_model.dart';

part 'tutor_model.g.dart';

/// Modelo de Tutor
@JsonSerializable()
class TutorModel {
  final int id;
  final String nombre;
  final String apellido;
  final String rol;

  @JsonKey(name: 'fecha_nacimiento')
  final String fechaNacimiento; // Formato: "YYYY-MM-DD"

  final String ci;
  final String direccion;

  @JsonKey(name: 'created_at')
  final String createdAt;

  final UsuarioModel usuario;

  TutorModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.rol,
    required this.fechaNacimiento,
    required this.ci,
    required this.direccion,
    required this.createdAt,
    required this.usuario,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) =>
      _$TutorModelFromJson(json);
  Map<String, dynamic> toJson() => _$TutorModelToJson(this);

  String get nombreCompleto => '$nombre $apellido';

  TutorModel copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? rol,
    String? fechaNacimiento,
    String? ci,
    String? direccion,
    String? createdAt,
    UsuarioModel? usuario,
  }) {
    return TutorModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      rol: rol ?? this.rol,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      ci: ci ?? this.ci,
      direccion: direccion ?? this.direccion,
      createdAt: createdAt ?? this.createdAt,
      usuario: usuario ?? this.usuario,
    );
  }
}

/// Modelo para crear Tutor
@JsonSerializable()
class TutorCreateModel {
  final String nombre;
  final String apellido;
  final String rol;

  @JsonKey(name: 'fecha_nacimiento')
  final String fechaNacimiento; // Formato: "YYYY-MM-DD"

  final String ci;
  final String direccion;

  @JsonKey(name: 'usuario_id')
  final int usuarioId;

  TutorCreateModel({
    required this.nombre,
    required this.apellido,
    required this.rol,
    required this.fechaNacimiento,
    required this.ci,
    required this.direccion,
    required this.usuarioId,
  });

  factory TutorCreateModel.fromJson(Map<String, dynamic> json) =>
      _$TutorCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$TutorCreateModelToJson(this);
}

/// Modelo para actualizar Tutor
@JsonSerializable()
class TutorUpdateModel {
  final String? nombre;
  final String? apellido;
  final String? rol;

  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento;

  final String? ci;
  final String? direccion;

  TutorUpdateModel({
    this.nombre,
    this.apellido,
    this.rol,
    this.fechaNacimiento,
    this.ci,
    this.direccion,
  });

  factory TutorUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$TutorUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$TutorUpdateModelToJson(this);
}
