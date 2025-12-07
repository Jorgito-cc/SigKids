import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Servicio para obtener y monitorear ubicación del usuario
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  bool _serviceEnabled = false;

  // --------------------------
  // INICIALIZAR PERMISOS
  // --------------------------
  Future<bool> initializeLocationService() async {
    debugPrint('[LocationService] 🔍 Inicializando servicio de ubicación...');

    // Verificar si el servicio está habilitado
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      debugPrint('[LocationService] ❌ Servicio de ubicación deshabilitado');
      return false;
    }

    // Solicitar permisos
    final permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied) {
      final requestedPermission = await Geolocator.requestPermission();
      if (requestedPermission == LocationPermission.denied) {
        debugPrint('[LocationService] ❌ Permisos denegados');
        return false;
      }
    }

    if (permissionStatus == LocationPermission.deniedForever) {
      debugPrint('[LocationService] ❌ Permisos denegados permanentemente');
      await Geolocator.openLocationSettings();
      return false;
    }

    debugPrint('[LocationService] ✅ Servicio de ubicación inicializado');
    return true;
  }

  // --------------------------
  // OBTENER UBICACIÓN ACTUAL
  // --------------------------
  Future<LatLng?> getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 5),
      );

      debugPrint(
        '[LocationService] 📍 Ubicación actual: ${position.latitude}, ${position.longitude}',
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('[LocationService] ❌ Error obteniendo ubicación: $e');
      return null;
    }
  }

  // --------------------------
  // ESCUCHAR CAMBIOS DE UBICACIÓN
  // --------------------------
  Stream<LatLng> getLocationStream({
    int intervalSeconds = 20,
    int distanceMeters = 10,
  }) {
    debugPrint(
      '[LocationService] 📡 Iniciando stream de ubicación (cada ${intervalSeconds}s)',
    );

    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceMeters, // mínimo cambio de distancia
        timeLimit: Duration(seconds: intervalSeconds),
      ),
    ).map((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);
      debugPrint(
        '[LocationService] 📍 Nueva ubicación: ${position.latitude}, ${position.longitude}',
      );
      return latLng;
    });
  }

  // --------------------------
  // CALCULAR DISTANCIA ENTRE DOS PUNTOS
  // --------------------------
  double getDistanceBetween(LatLng from, LatLng to) {
    final distanceInMeters = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );

    return distanceInMeters;
  }

  // --------------------------
  // CONVERTIR LatLng a String
  // --------------------------
  String latLngToString(LatLng location) {
    return '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
  }

  // --------------------------
  // OBTENER DIRECCIÓN APROXIMADA
  // --------------------------
  Future<String> getApproximateAddress(LatLng location) async {
    try {
      // Usar Google Reverse Geocoding (opcional)
      // Por ahora devolvemos las coordenadas
      return latLngToString(location);
    } catch (e) {
      debugPrint('[LocationService] ❌ Error obteniendo dirección: $e');
      return latLngToString(location);
    }
  }
}
