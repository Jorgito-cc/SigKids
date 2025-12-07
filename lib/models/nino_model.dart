import 'package:json_annotation/json_annotation.dart';
import 'usuario_model.dart';

part 'nino_model.g.dart';

/// Modelo de Niño (Hijo)
@JsonSerializable()
class NinoModel {
  final int id;
  final String nombre;
  final String apellido;

  @JsonKey(name: 'fecha_nacimiento')
  final String fechaNacimiento; // Formato: "YYYY-MM-DD"

  final String telefono;
  final String direccion;

  @JsonKey(name: 'created_at')
  final String createdAt;

  final UsuarioModel usuario;

  NinoModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.telefono,
    required this.direccion,
    required this.createdAt,
    required this.usuario,
  });

  factory NinoModel.fromJson(Map<String, dynamic> json) =>
      _$NinoModelFromJson(json);
  Map<String, dynamic> toJson() => _$NinoModelToJson(this);

  String get nombreCompleto => '$nombre $apellido';

  /// Calcular edad aproximada
  int get edad {
    try {
      final birthDate = DateTime.parse(fechaNacimiento);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  NinoModel copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? fechaNacimiento,
    String? telefono,
    String? direccion,
    String? createdAt,
    UsuarioModel? usuario,
  }) {
    return NinoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      createdAt: createdAt ?? this.createdAt,
      usuario: usuario ?? this.usuario,
    );
  }
}

/// Modelo para crear Niño
@JsonSerializable()
class NinoCreateModel {
  final String nombre;
  final String apellido;

  @JsonKey(name: 'fecha_nacimiento')
  final String fechaNacimiento; // Formato: "YYYY-MM-DD"

  final String telefono;
  final String direccion;

  @JsonKey(name: 'usuario_id')
  final int usuarioId;

  NinoCreateModel({
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.telefono,
    required this.direccion,
    required this.usuarioId,
  });

  factory NinoCreateModel.fromJson(Map<String, dynamic> json) =>
      _$NinoCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$NinoCreateModelToJson(this);
}

/// Modelo para actualizar Niño
@JsonSerializable()
class NinoUpdateModel {
  final String? nombre;
  final String? apellido;

  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento;

  final String? telefono;
  final String? direccion;

  NinoUpdateModel({
    this.nombre,
    this.apellido,
    this.fechaNacimiento,
    this.telefono,
    this.direccion,
  });

  factory NinoUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$NinoUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$NinoUpdateModelToJson(this);
}
