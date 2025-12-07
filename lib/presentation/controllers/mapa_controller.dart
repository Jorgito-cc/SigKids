import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../api/area_api.dart';
import '../../api/hijo_api.dart';
import '../../api/ubicacion_api.dart';
import '../../models/area_model.dart';
import '../../models/nino_model.dart';
import '../../models/ubicacion_model.dart';
import '../../services/location_service.dart';
import '../../services/monitoreo_service.dart';

class MapaController extends GetxController {
  final AreaApi _areaApi = AreaApi();
  final HijoApi _hijoApi = HijoApi();
  final UbicacionApi _ubicacionApi = UbicacionApi();
  final LocationService _locationService = LocationService();
  final MonitoreoService _monitoreoService = MonitoreoService();

  // ==================== ESTADO REACTIVO ====================

  // Área seleccionada
  Rxn<AreaModel> selectedArea = Rxn<AreaModel>();

  // Niño/Hijo siendo monitoreado
  Rxn<NinoModel> selectedNino = Rxn<NinoModel>();

  // Ubicación actual del hijo
  Rxn<LatLng> ninoLocation = Rxn<LatLng>();

  // Ubicación de la cámara del mapa
  Rxn<LatLng> cameraLocation = Rxn<LatLng>();

  // Vértices del área (polígono)
  RxList<LatLng> areaVertices = RxList<LatLng>([]);

  // Indica si está en modo edición (dibujando área)
  RxBool isEditingMode = false.obs;

  // Indica si está monitoreando en tiempo real
  RxBool isMonitoring = false.obs;

  // Ubicación dentro del área
  RxBool isNinoInsideArea = false.obs;

  // Historial de ubicaciones del niño
  RxList<UbicacionModel> locationHistory = RxList<UbicacionModel>([]);

  // Cargando datos
  RxBool isLoading = false.obs;

  // ==================== CONTROLLERS ====================

  GoogleMapController? mapController;
  StreamSubscription<LatLng>? _locationStreamSubscription;

  // ==================== CICLO DE VIDA ====================

  @override
  void onInit() {
    super.onInit();
    debugPrint('[MapaController] 🔄 Inicializando...');
    _initializeMap();
  }

  @override
  void onClose() {
    debugPrint('[MapaController] 🔴 Cerrando...');
    stopMonitoring();
    _locationStreamSubscription?.cancel();
    mapController?.dispose();
    super.onClose();
  }

  // ==================== INICIALIZACIÓN ====================

  Future<void> _initializeMap() async {
    isLoading.value = true;

    try {
      // Obtener ubicación actual del usuario
      final LatLng? userLocation = await _locationService.getCurrentLocation();

      if (userLocation != null) {
        cameraLocation.value = userLocation;
      } else {
        // Default a una ubicación
        cameraLocation.value = const LatLng(37.7749, -122.4194);
      }

      debugPrint(
        '[MapaController] ✅ Mapa inicializado en ${cameraLocation.value}',
      );
    } catch (e) {
      debugPrint('[MapaController] ❌ Error inicializando: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CARGAR DATOS ====================

  /// Cargar área y datos asociados
  Future<void> loadArea(String areaId) async {
    isLoading.value = true;

    try {
      final int id = int.tryParse(areaId) ?? 0;
      if (id == 0) throw Exception('ID de área inválido');

      final area = await _areaApi.getAreaById(id);
      selectedArea.value = area;

      // Convertir vértices JSON a LatLng
      _parseAreaVertices(area);

      debugPrint('[MapaController] ✅ Área cargada: ${area.nombre}');
    } catch (e) {
      debugPrint('[MapaController] ❌ Error cargando área: $e');
      Get.snackbar('Error', 'Error cargando área: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar niño y su ubicación actual
  Future<void> loadNino(String ninoId) async {
    isLoading.value = true;

    try {
      final int id = int.tryParse(ninoId) ?? 0;
      if (id == 0) throw Exception('ID de niño inválido');

      final nino = await _hijoApi.getHijoById(id);
      selectedNino.value = nino;

      // Obtener ubicación actual
      final ubicacion = await _ubicacionApi.getUbicacionActual(id);
      if (ubicacion != null) {
        ninoLocation.value = ubicacion.latLng;
      }

      debugPrint('[MapaController] ✅ Niño cargado: ${nino.nombre}');
    } catch (e) {
      debugPrint('[MapaController] ❌ Error cargando niño: $e');
      Get.snackbar('Error', 'Error cargando niño: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cargar historial de ubicaciones
  Future<void> loadLocationHistory(int ninoId) async {
    try {
      final history = await _ubicacionApi.getHistorialUbicaciones(
        ninoId: ninoId,
        limit: 50,
      );
      locationHistory.value = history;
      debugPrint(
        '[MapaController] ✅ Historial cargado: ${history.length} puntos',
      );
    } catch (e) {
      debugPrint('[MapaController] ❌ Error cargando historial: $e');
    }
  }

  // ==================== MONITOREO EN TIEMPO REAL ====================

  /// Iniciar monitoreo del niño
  Future<void> startMonitoring({
    required String ninoId,
    required String areaId,
  }) async {
    if (isMonitoring.value) {
      debugPrint('[MapaController] ⚠️ Ya está en monitoreo');
      return;
    }

    try {
      debugPrint('[MapaController] 🚀 Iniciando monitoreo...');

      // Iniciar monitoreo del servicio
      await _monitoreoService.startMonitoreo(
        hijoId: ninoId,
        areaId: areaId,
        intervalSeconds: 20,
      );

      isMonitoring.value = true;

      // Escuchar cambios de ubicación
      _locationStreamSubscription = _monitoreoService
          .monitorLocationStream(intervalSeconds: 20)
          .listen((LatLng location) {
        _updateNinoLocation(location);
      });

      Get.snackbar(
        'Monitoreo',
        'Monitoreo iniciado',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('[MapaController] ❌ Error iniciando monitoreo: $e');
      Get.snackbar('Error', 'Error iniciando monitoreo');
    }
  }

  /// Detener monitoreo
  void stopMonitoring() {
    if (!isMonitoring.value) return;

    try {
      _monitoreoService.stopMonitoreo();
      _locationStreamSubscription?.cancel();
      isMonitoring.value = false;

      debugPrint('[MapaController] ⏹️ Monitoreo detenido');
      Get.snackbar(
        'Monitoreo',
        'Monitoreo detenido',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('[MapaController] ❌ Error deteniendo monitoreo: $e');
    }
  }

  // ==================== MAPA - ACTUALIZAR POSICIÓN ====================

  void _updateNinoLocation(LatLng location) {
    ninoLocation.value = location;

    // Actualizar cámara si está centrada en el niño
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: location,
          zoom: 16,
        ),
      ),
    );

    // Verificar si está dentro del área
    _checkIfInsideArea(location);

    debugPrint(
      '[MapaController] 📍 Ubicación actualizada: '
      '${location.latitude.toStringAsFixed(4)}, '
      '${location.longitude.toStringAsFixed(4)}',
    );
  }

  // ==================== VERIFICAR DENTRO/FUERA DE ÁREA ====================

  void _checkIfInsideArea(LatLng location) {
    if (areaVertices.isEmpty) {
      isNinoInsideArea.value = true;
      return;
    }

    final isInside = _monitoreoService.isPointInPolygon(
      location,
      areaVertices,
    );

    isNinoInsideArea.value = isInside;

    // Log para debug
    final status = isInside ? '✅ DENTRO' : '⚠️ FUERA';
    debugPrint('[MapaController] $status del área');

    // Aquí iría lógica para mostrar notificación si está fuera
    if (!isInside) {
      _showAlertOutsideArea();
    }
  }

  void _showAlertOutsideArea() {
    // Mostrar notificación local (implementar en siguiente fase)
    debugPrint('[MapaController] 🔔 ¡ALERTA! El niño está fuera del área');
  }

  // ==================== EDICIÓN DE ÁREA ====================

  /// Entrar en modo edición (dibujar polígono)
  void enterEditMode() {
    isEditingMode.value = true;
    areaVertices.clear();
    debugPrint('[MapaController] ✏️ Modo edición activado');
  }

  /// Salir de modo edición
  void exitEditMode() {
    isEditingMode.value = false;
    debugPrint('[MapaController] ✔️ Modo edición desactivado');
  }

  /// Agregar vértice al polígono
  void addVertex(LatLng vertex) {
    if (!isEditingMode.value) return;

    areaVertices.add(vertex);
    debugPrint(
      '[MapaController] 📌 Vértice agregado: ${vertex.latitude}, ${vertex.longitude}',
    );
  }

  /// Deshacer último vértice
  void undoLastVertex() {
    if (areaVertices.isEmpty) return;
    areaVertices.removeLast();
    debugPrint('[MapaController] ↶ Último vértice deshecho');
  }

  /// Guardar área con vértices
  Future<void> saveArea({
    required String nombreArea,
    required String tutorId,
  }) async {
    if (areaVertices.length < 3) {
      Get.snackbar('Error', 'Se necesitan mínimo 3 vértices');
      return;
    }

    isLoading.value = true;

    try {
      // Crear modelo del área
      final areaCreate = AreaCreateModel(
        nombre: nombreArea,
        vertices: areaVertices
            .map(
              (latLng) => {
                'lat': latLng.latitude,
                'lng': latLng.longitude,
              },
            )
            .toList(),
        idTutorCreador: int.tryParse(tutorId) ?? 0,
      );

      // Guardar en backend
      final nuevaArea = await _areaApi.createArea(areaCreate);
      selectedArea.value = nuevaArea;

      exitEditMode();

      Get.snackbar('Éxito', 'Área guardada correctamente');
      debugPrint('[MapaController] ✅ Área guardada: ${nuevaArea.nombre}');
    } catch (e) {
      debugPrint('[MapaController] ❌ Error guardando área: $e');
      Get.snackbar('Error', 'Error guardando área: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== UTILIDADES ====================

  /// Parsear vértices de área desde JSON
  void _parseAreaVertices(AreaModel area) {
    try {
      if (area.vertices is String) {
        // Si es string JSON, parsear
        // Implementar según formato del backend
      } else {
        // Si es lista de mapas
        final List<dynamic> vertices = area.vertices;
        areaVertices.clear();

        for (final vertex in vertices) {
          if (vertex is Map<String, dynamic>) {
            final lat = vertex['lat'] as double?;
            final lng = vertex['lng'] as double?;

            if (lat != null && lng != null) {
              areaVertices.add(LatLng(lat, lng));
            }
          }
        }
      }

      debugPrint(
        '[MapaController] 📍 Vértices parseados: ${areaVertices.length}',
      );
    } catch (e) {
      debugPrint('[MapaController] ❌ Error parseando vértices: $e');
    }
  }

  /// Centrar mapa en niño
  Future<void> centerMapOnNino() async {
    if (ninoLocation.value == null) return;

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: ninoLocation.value!,
          zoom: 16,
        ),
      ),
    );
  }

  /// Centrar mapa en área
  Future<void> centerMapOnArea() async {
    if (areaVertices.isEmpty) return;

    // Calcular centro del área
    double minLat = areaVertices.first.latitude;
    double maxLat = areaVertices.first.latitude;
    double minLng = areaVertices.first.longitude;
    double maxLng = areaVertices.first.longitude;

    for (final vertex in areaVertices) {
      if (vertex.latitude < minLat) minLat = vertex.latitude;
      if (vertex.latitude > maxLat) maxLat = vertex.latitude;
      if (vertex.longitude < minLng) minLng = vertex.longitude;
      if (vertex.longitude > maxLng) maxLng = vertex.longitude;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(centerLat, centerLng),
          zoom: 14,
        ),
      ),
    );
  }

  /// Obtener color del marcador según estado
  BitmapDescriptor getMarkerColor() {
    return isNinoInsideArea.value
        ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
        : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }
}
