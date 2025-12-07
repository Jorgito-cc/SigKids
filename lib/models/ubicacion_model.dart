import 'package:json_annotation/json_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'ubicacion_model.g.dart';

/// Modelo de Ubicación
@JsonSerializable()
class UbicacionModel {
  final int id;
  final double latitud;
  final double longitud;

  @JsonKey(name: 'esta_dentro')
  final bool estaDentro;

  @JsonKey(name: 'fecha_hora')
  final String fechaHora; // ISO 8601 format

  @JsonKey(name: 'id_area')
  final int idArea;

  @JsonKey(name: 'id_nino')
  final int idNino;

  UbicacionModel({
    required this.id,
    required this.latitud,
    required this.longitud,
    required this.estaDentro,
    required this.fechaHora,
    required this.idArea,
    required this.idNino,
  });

  factory UbicacionModel.fromJson(Map<String, dynamic> json) =>
      _$UbicacionModelFromJson(json);
  Map<String, dynamic> toJson() => _$UbicacionModelToJson(this);

  /// Convertir a LatLng
  LatLng get latLng => LatLng(latitud, longitud);

  /// Obtener DateTime
  DateTime get dateTime {
    try {
      return DateTime.parse(fechaHora);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Formatear coordenadas
  String get coordenadasFormateadas =>
      '${latitud.toStringAsFixed(6)}, ${longitud.toStringAsFixed(6)}';

  UbicacionModel copyWith({
    int? id,
    double? latitud,
    double? longitud,
    bool? estaDentro,
    String? fechaHora,
    int? idArea,
    int? idNino,
  }) {
    return UbicacionModel(
      id: id ?? this.id,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      estaDentro: estaDentro ?? this.estaDentro,
      fechaHora: fechaHora ?? this.fechaHora,
      idArea: idArea ?? this.idArea,
      idNino: idNino ?? this.idNino,
    );
  }
}

/// Modelo para crear Ubicación
@JsonSerializable()
class UbicacionCreateModel {
  final double latitud;
  final double longitud;

  @JsonKey(name: 'esta_dentro')
  final bool estaDentro;

  @JsonKey(name: 'id_area')
  final int idArea;

  @JsonKey(name: 'id_nino')
  final int idNino;

  UbicacionCreateModel({
    required this.latitud,
    required this.longitud,
    required this.estaDentro,
    required this.idArea,
    required this.idNino,
  });

  /// Constructor desde LatLng
  factory UbicacionCreateModel.fromLatLng({
    required LatLng position,
    required bool estaDentro,
    required int idArea,
    required int idNino,
  }) {
    return UbicacionCreateModel(
      latitud: position.latitude,
      longitud: position.longitude,
      estaDentro: estaDentro,
      idArea: idArea,
      idNino: idNino,
    );
  }

  factory UbicacionCreateModel.fromJson(Map<String, dynamic> json) =>
      _$UbicacionCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$UbicacionCreateModelToJson(this);
}

/// Modelo para historial de ubicaciones
@JsonSerializable()
class UbicacionHistorialModel {
  final List<UbicacionModel> ubicaciones;
  final int total;

  @JsonKey(name: 'nino_id')
  final int ninoId;

  @JsonKey(name: 'area_id')
  final int? areaId;

  UbicacionHistorialModel({
    required this.ubicaciones,
    required this.total,
    required this.ninoId,
    this.areaId,
  });

  factory UbicacionHistorialModel.fromJson(Map<String, dynamic> json) =>
      _$UbicacionHistorialModelFromJson(json);
  Map<String, dynamic> toJson() => _$UbicacionHistorialModelToJson(this);

  /// Obtener todas las ubicaciones como LatLng
  List<LatLng> get recorrido => ubicaciones.map((u) => u.latLng).toList();

  /// Contar ubicaciones dentro del área
  int get dentroDelArea => ubicaciones.where((u) => u.estaDentro).length;

  /// Contar ubicaciones fuera del área
  int get fueraDelArea => ubicaciones.where((u) => !u.estaDentro).length;

  /// Porcentaje dentro del área
  double get porcentajeDentro {
    if (ubicaciones.isEmpty) return 0;
    return (dentroDelArea / ubicaciones.length) * 100;
  }
}
