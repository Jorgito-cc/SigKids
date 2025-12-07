import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/geo_utils.dart';

part 'area_model.g.dart';

/// Modelo de Área de monitoreo
@JsonSerializable()
class AreaModel {
  final int id;
  final String nombre;

  /// Vértices del polígono en formato JSON
  /// Ejemplo: [{"lat": -32.9460, "lng": -60.6391}, ...]
  final List<Map<String, dynamic>> vertices;

  final String estado; // "ACTIVO" o "INACTIVO"

  @JsonKey(name: 'id_tutor_creador')
  final int idTutorCreador;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  AreaModel({
    required this.id,
    required this.nombre,
    required this.vertices,
    required this.estado,
    required this.idTutorCreador,
    this.createdAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);
  Map<String, dynamic> toJson() => _$AreaModelToJson(this);

  /// Convertir vértices JSON a lista de LatLng
  List<LatLng> get verticesLatLng {
    return vertices.map((v) {
      return LatLng(
        (v['lat'] as num).toDouble(),
        (v['lng'] as num).toDouble(),
      );
    }).toList();
  }

  /// Verificar si el área está activa
  bool get isActiva => estado.toUpperCase() == 'ACTIVO';

  /// Obtener centro del polígono
  LatLng get centro => GeoUtils.calculatePolygonCenter(verticesLatLng);

  /// Calcular área en metros cuadrados
  double get areaMetrosCuadrados =>
      GeoUtils.calculatePolygonArea(verticesLatLng);

  /// Verificar si un punto está dentro del área
  bool contienePunto(LatLng punto) {
    return GeoUtils.isPointInPolygon(punto, verticesLatLng);
  }

  AreaModel copyWith({
    int? id,
    String? nombre,
    List<Map<String, dynamic>>? vertices,
    String? estado,
    int? idTutorCreador,
    String? createdAt,
  }) {
    return AreaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      vertices: vertices ?? this.vertices,
      estado: estado ?? this.estado,
      idTutorCreador: idTutorCreador ?? this.idTutorCreador,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Modelo para crear Área
@JsonSerializable()
class AreaCreateModel {
  final String nombre;
  final List<Map<String, dynamic>> vertices;
  final String estado;

  @JsonKey(name: 'id_tutor_creador')
  final int idTutorCreador;

  AreaCreateModel({
    required this.nombre,
    required this.vertices,
    this.estado = 'ACTIVO',
    required this.idTutorCreador,
  });

  /// Constructor desde lista de LatLng
  factory AreaCreateModel.fromLatLng({
    required String nombre,
    required List<LatLng> vertices,
    String estado = 'ACTIVO',
    required int idTutorCreador,
  }) {
    return AreaCreateModel(
      nombre: nombre,
      vertices: GeoUtils.polygonToJson(vertices),
      estado: estado,
      idTutorCreador: idTutorCreador,
    );
  }

  factory AreaCreateModel.fromJson(Map<String, dynamic> json) =>
      _$AreaCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$AreaCreateModelToJson(this);
}

/// Modelo para actualizar Área
@JsonSerializable()
class AreaUpdateModel {
  final String? nombre;
  final List<Map<String, dynamic>>? vertices;
  final String? estado;

  AreaUpdateModel({
    this.nombre,
    this.vertices,
    this.estado,
  });

  factory AreaUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$AreaUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$AreaUpdateModelToJson(this);
}

/// Modelo para asignar niños a un área
@JsonSerializable()
class AreaAsignacionModel {
  @JsonKey(name: 'area_id')
  final int areaId;

  @JsonKey(name: 'nino_ids')
  final List<int> ninoIds;

  AreaAsignacionModel({
    required this.areaId,
    required this.ninoIds,
  });

  factory AreaAsignacionModel.fromJson(Map<String, dynamic> json) =>
      _$AreaAsignacionModelFromJson(json);
  Map<String, dynamic> toJson() => _$AreaAsignacionModelToJson(this);
}
