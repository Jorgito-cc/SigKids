import 'package:get/get.dart';
import '../../api/hijo_api.dart';
import '../../config/local_storage.dart';
import 'package:flutter/material.dart';

class HomeHijoController extends GetxController {
  final HijoApi _hijoApi = HijoApi();
  final LocalStorage _storage = LocalStorage();

  final isLoading = false.obs;
  final hijoNombre = ''.obs;
  final isLocationSharing = false.obs;
  final tutores = <Map<String, dynamic>>[].obs;
  final areas = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🟦 HomeHijoController → onInit()");
    _loadHijoData();
    _loadTutores();
    _loadAreas(); // ← LO QUE FALTABA
  }

  // ===============================
  // CARGAR DATOS DEL HIJO
  // ===============================
  void _loadHijoData() {
    final hijoData = _storage.getHijo();
    debugPrint("📥 Leyendo hijo desde LocalStorage: $hijoData");

    if (hijoData != null) {
      hijoNombre.value = '${hijoData['nombre']} ${hijoData['apellido']}';
      debugPrint("👤 Nombre hijo establecido: ${hijoNombre.value}");
    } else {
      debugPrint("❌ No se encontró hijo en LocalStorage");
    }
  }

  // ===============================
  // CARGAR TUTORES DEL HIJO
  // ===============================
  Future<void> _loadTutores() async {
    try {
      debugPrint("🔵 INICIANDO carga de tutores...");
      isLoading.value = true;

      final hijoData = _storage.getHijo();
      debugPrint("📦 hijoData obtenido: $hijoData");

      if (hijoData == null) {
        debugPrint("❌ hijoData es null. No se puede cargar tutores.");
        return;
      }

      final hijoId = hijoData['id'] as int;
      debugPrint("📤 Solicitando tutores a API con hijoId: $hijoId");

      final hijoWithTutores = await _hijoApi.getHijoWithTutores(hijoId);
      debugPrint("📥 Respuesta API tutores: $hijoWithTutores");

      final tutoresList = hijoWithTutores['tutores'] as List?;
      if (tutoresList != null) {
        tutores.value = tutoresList.cast<Map<String, dynamic>>();
        debugPrint("✅ Tutores cargados: ${tutores.length}");
      } else {
        debugPrint("📭 El hijo no tiene tutores asignados.");
      }
    } catch (e) {
      debugPrint("❌ ERROR cargando tutores: $e");
    } finally {
      isLoading.value = false;
      debugPrint("🔚 FIN carga de tutores");
    }
  }

  // ===============================
  // CARGAR ÁREAS DEL HIJO
  // ===============================
  Future<void> _loadAreas() async {
    try {
      debugPrint("🟣 INICIANDO carga de ÁREAS...");
      final hijoData = _storage.getHijo();
      debugPrint("📦 hijoData obtenido para áreas: $hijoData");

      if (hijoData == null) {
        debugPrint("❌ hijoData es null. No se puede cargar áreas.");
        return;
      }

      final hijoId = hijoData['id'] as int;
      debugPrint("📤 Solicitando áreas a API con hijoId: $hijoId");

     // final hijoWithAreas = await _hijoApi.getHijoWithAreas(hijoId);
     // debugPrint("📥 Respuesta API áreas: $hijoWithAreas");

      //final areasList = hijoWithAreas['areas'] as List?;
      //if (areasList != null) {
      //  areas.value = areasList.cast<Map<String, dynamic>>();
       // debugPrint("✅ Áreas cargadas: ${areas.length}");
     // } else {
       // debugPrint("📭 El hijo no tiene áreas asignadas.");
     // }
    } catch (e) {
      debugPrint("❌ ERROR cargando áreas: $e");
    } finally {
      debugPrint("🔚 FIN carga de áreas");
    }
  }

  // ===============================
  // UBICACIÓN
  // ===============================
  void toggleLocationSharing() {
    isLocationSharing.value = !isLocationSharing.value;
    debugPrint("📍 Estado de ubicación cambiado a: ${isLocationSharing.value}");

    if (isLocationSharing.value) {
      _startLocationSharing();
    } else {
      _stopLocationSharing();
    }
  }

  void _startLocationSharing() {
    debugPrint("📡 INICIANDO compartición de ubicación...");
    Get.snackbar(
      'Ubicación Activada',
      'Compartiendo tu ubicación con tus tutores',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _stopLocationSharing() {
    debugPrint("🛑 Deteniendo compartición de ubicación...");
    Get.snackbar(
      'Ubicación Desactivada',
      'Ya no compartes tu ubicación',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
