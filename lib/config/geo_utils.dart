import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ll;

/// Utilidades para cálculos SIG (Sistemas de Información Geográfica)
class GeoUtils {
  /// Algoritmo Ray Casting para determinar si un punto está dentro de un polígono
  ///
  /// Parámetros:
  /// - [point]: Punto a verificar (LatLng)
  /// - [polygon]: Lista de vértices del polígono (List<LatLng>)
  ///
  /// Retorna: true si el punto está dentro del polígono, false si está fuera
  static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    if (polygon.length < 3) {
      return false; // Un polígono necesita al menos 3 vértices
    }

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      double xi = polygon[i].latitude;
      double yi = polygon[i].longitude;
      double xj = polygon[j].latitude;
      double yj = polygon[j].longitude;

      bool intersect = ((yi > point.longitude) != (yj > point.longitude)) &&
          (point.latitude <
              (xj - xi) * (point.longitude - yi) / (yj - yi) + xi);

      if (intersect) {
        inside = !inside;
      }

      j = i;
    }

    return inside;
  }

  /// Calcular distancia entre dos puntos usando la fórmula de Haversine
  ///
  /// Parámetros:
  /// - [point1]: Primer punto (LatLng)
  /// - [point2]: Segundo punto (LatLng)
  ///
  /// Retorna: Distancia en metros
  static double calculateDistance(LatLng point1, LatLng point2) {
    final ll.Distance distance = ll.Distance();
    return distance.as(
      ll.LengthUnit.Meter,
      ll.LatLng(point1.latitude, point1.longitude),
      ll.LatLng(point2.latitude, point2.longitude),
    );
  }

  /// Calcular el centro (centroide) de un polígono
  ///
  /// Parámetros:
  /// - [polygon]: Lista de vértices del polígono
  ///
  /// Retorna: Punto central del polígono (LatLng)
  static LatLng calculatePolygonCenter(List<LatLng> polygon) {
    if (polygon.isEmpty) {
      return const LatLng(0, 0);
    }

    double latSum = 0;
    double lngSum = 0;

    for (var point in polygon) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }

    return LatLng(
      latSum / polygon.length,
      lngSum / polygon.length,
    );
  }

  /// Calcular el área de un polígono en metros cuadrados
  ///
  /// Parámetros:
  /// - [polygon]: Lista de vértices del polígono
  ///
  /// Retorna: Área en metros cuadrados
  static double calculatePolygonArea(List<LatLng> polygon) {
    if (polygon.length < 3) {
      return 0;
    }

    double area = 0;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      area += (polygon[j].longitude + polygon[i].longitude) *
          (polygon[j].latitude - polygon[i].latitude);
      j = i;
    }

    area = area.abs() / 2;

    // Convertir de grados cuadrados a metros cuadrados (aproximación)
    // 1 grado de latitud ≈ 111,320 metros
    // 1 grado de longitud varía según la latitud
    double avgLat =
        polygon.map((p) => p.latitude).reduce((a, b) => a + b) / polygon.length;
    double latToMeters = 111320;
    double lngToMeters = 111320 * math.cos(avgLat * math.pi / 180);

    return area * latToMeters * lngToMeters;
  }

  /// Verificar si un polígono es válido (mínimo 3 vértices y no auto-intersecante)
  ///
  /// Parámetros:
  /// - [polygon]: Lista de vértices del polígono
  ///
  /// Retorna: true si el polígono es válido
  static bool isValidPolygon(List<LatLng> polygon) {
    if (polygon.length < 3) {
      return false;
    }

    // Verificar que no haya vértices duplicados consecutivos
    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;
      if (polygon[i].latitude == polygon[j].latitude &&
          polygon[i].longitude == polygon[j].longitude) {
        return false;
      }
    }

    return true;
  }

  /// Convertir lista de LatLng a JSON
  ///
  /// Parámetros:
  /// - [polygon]: Lista de vértices del polígono
  ///
  /// Retorna: Lista de mapas con lat/lng
  static List<Map<String, double>> polygonToJson(List<LatLng> polygon) {
    return polygon
        .map((point) => {
              'lat': point.latitude,
              'lng': point.longitude,
            })
        .toList();
  }

  /// Convertir JSON a lista de LatLng
  ///
  /// Parámetros:
  /// - [json]: Lista de mapas con lat/lng
  ///
  /// Retorna: Lista de LatLng
  static List<LatLng> jsonToPolygon(List<dynamic> json) {
    return json.map((point) {
      return LatLng(
        (point['lat'] as num).toDouble(),
        (point['lng'] as num).toDouble(),
      );
    }).toList();
  }

  /// Formatear coordenadas para mostrar
  ///
  /// Parámetros:
  /// - [lat]: Latitud
  /// - [lng]: Longitud
  /// - [decimals]: Número de decimales (por defecto 6)
  ///
  /// Retorna: String formateado
  static String formatCoordinates(double lat, double lng, {int decimals = 6}) {
    return '${lat.toStringAsFixed(decimals)}, ${lng.toStringAsFixed(decimals)}';
  }

  /// Obtener bounds (límites) de un polígono para ajustar la cámara del mapa
  ///
  /// Parámetros:
  /// - [polygon]: Lista de vértices del polígono
  ///
  /// Retorna: LatLngBounds
  static LatLngBounds getPolygonBounds(List<LatLng> polygon) {
    if (polygon.isEmpty) {
      return LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(0, 0),
      );
    }

    double minLat = polygon.first.latitude;
    double maxLat = polygon.first.latitude;
    double minLng = polygon.first.longitude;
    double maxLng = polygon.first.longitude;

    for (var point in polygon) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
