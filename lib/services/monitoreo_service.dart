import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../api/ubicacion_api.dart';
import '../models/ubicacion_model.dart';

import 'location_service.dart';

/// Servicio para monitorear y enviar ubicación al backend
class MonitoreoService {
  static final MonitoreoService _instance = MonitoreoService._internal();
  factory MonitoreoService() => _instance;
  MonitoreoService._internal();

  final LocationService _locationService = LocationService();
  final UbicacionApi _ubicacionApi = UbicacionApi();

  Timer? _monitoreoTimer;
  bool _isMonitoring = false;

  // Para saber si está en monitoreo
  bool get isMonitoring => _isMonitoring;

  // --------------------------
  // INICIAR MONITOREO
  // --------------------------
  Future<void> startMonitoreo({
    required String hijoId,
    required String areaId,
    int intervalSeconds = 20,
  }) async {
    if (_isMonitoring) {
      debugPrint('[MonitoreoService] ⚠️ Ya está en monitoreo');
      return;
    }

    debugPrint(
      '[MonitoreoService] 🚀 Iniciando monitoreo para hijo: $hijoId, área: $areaId',
    );

    _isMonitoring = true;

    // Obtener ubicación y enviar inmediatamente
    _sendLocationToBackend(hijoId, areaId);

    // Luego programar envíos periódicos
    _monitoreoTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _sendLocationToBackend(hijoId, areaId),
    );
  }

  // --------------------------
  // DETENER MONITOREO
  // --------------------------
  void stopMonitoreo() {
    debugPrint('[MonitoreoService] ⏹️ Deteniendo monitoreo');

    _monitoreoTimer?.cancel();
    _isMonitoring = false;
  }

  // --------------------------
  // ENVIAR UBICACIÓN AL BACKEND
  // --------------------------
  Future<void> _sendLocationToBackend(
    String hijoId,
    String areaId, {
    bool estaDentro = true,
  }) async {
    if (!_isMonitoring) return;

    try {
      // Obtener ubicación actual
      final LatLng? currentLocation =
          await _locationService.getCurrentLocation();

      if (currentLocation == null) {
        debugPrint('[MonitoreoService] ❌ No se pudo obtener ubicación');
        return;
      }

      // Convertir strings a int
      final int idNino = int.tryParse(hijoId) ?? 0;
      final int idArea = int.tryParse(areaId) ?? 0;

      if (idNino == 0 || idArea == 0) {
        debugPrint('[MonitoreoService] ❌ IDs inválidos');
        return;
      }

      // Crear modelo de ubicación
      final ubicacionModel = UbicacionCreateModel(
        latitud: currentLocation.latitude,
        longitud: currentLocation.longitude,
        estaDentro: estaDentro,
        idNino: idNino,
        idArea: idArea,
      );

      // Enviar al backend
      try {
        await _ubicacionApi.createUbicacion(ubicacionModel);

        debugPrint(
          '[MonitoreoService] ✅ Ubicación enviada: '
          '${currentLocation.latitude.toStringAsFixed(4)}, '
          '${currentLocation.longitude.toStringAsFixed(4)}',
        );
      } catch (apiError) {
        debugPrint('[MonitoreoService] ❌ Error API: $apiError');
      }
    } catch (e) {
      debugPrint('[MonitoreoService] ❌ Error enviando ubicación: $e');
    }
  }

  // --------------------------
  // MONITOREAR EN TIEMPO REAL (STREAM)
  // --------------------------
  Stream<LatLng> monitorLocationStream({
    int intervalSeconds = 20,
    int distanceMeters = 10,
  }) {
    return _locationService.getLocationStream(
      intervalSeconds: intervalSeconds,
      distanceMeters: distanceMeters,
    );
  }

  // --------------------------
  // OBTENER ÚLTIMA UBICACIÓN CONOCIDA
  // --------------------------
  Future<LatLng?> getLastKnownLocation() async {
    try {
      final Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return LatLng(lastPosition.latitude, lastPosition.longitude);
      }
      return null;
    } catch (e) {
      debugPrint('[MonitoreoService] ❌ Error obteniendo última ubicación: $e');
      return null;
    }
  }

  // --------------------------
  // VERIFICAR SI ESTÁ EN ÁREA (SIMPLE)
  // --------------------------
  bool isPointInPolygon(
    LatLng point,
    List<LatLng> polygonVertices,
  ) {
    if (polygonVertices.length < 3) return false;

    int intersectCount = 0;
    for (int i = 0; i < polygonVertices.length; i++) {
      final p1 = polygonVertices[i];
      final p2 = polygonVertices[(i + 1) % polygonVertices.length];

      if (_rayCastingAlgorithm(point, p1, p2)) {
        intersectCount++;
      }
    }

    return intersectCount % 2 == 1;
  }

  bool _rayCastingAlgorithm(LatLng point, LatLng p1, LatLng p2) {
    final lat = point.latitude;
    final lng = point.longitude;

    if ((p1.latitude <= lat && lat < p2.latitude) ||
        (p2.latitude <= lat && lat < p1.latitude)) {
      final slope = (p2.longitude - p1.longitude) / (p2.latitude - p1.latitude);
      final intersectLng = p1.longitude + slope * (lat - p1.latitude);

      if (lng < intersectLng) {
        return true;
      }
    }

    return false;
  }

  // --------------------------
  // LIMPIAR RECURSOS
  // --------------------------
  void dispose() {
    stopMonitoreo();
  }
}
