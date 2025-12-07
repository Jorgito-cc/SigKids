import 'package:get/get.dart';
import '../../api/hijo_api.dart';
import '../../config/local_storage.dart';

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
    _loadHijoData();
    _loadTutores();
  }

  void _loadHijoData() {
    final hijoData = _storage.getHijo();
    if (hijoData != null) {
      hijoNombre.value = '${hijoData['nombre']} ${hijoData['apellido']}';
    }
  }

  Future<void> _loadTutores() async {
    try {
      isLoading.value = true;

      final hijoData = _storage.getHijo();
      if (hijoData == null) return;

      final hijoId = hijoData['id'] as int;
      final hijoWithTutores = await _hijoApi.getHijoWithTutores(hijoId);

      final tutoresList = hijoWithTutores['tutores'] as List?;
      if (tutoresList != null) {
        tutores.value = tutoresList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error cargando tutores: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLocationSharing() {
    isLocationSharing.value = !isLocationSharing.value;

    if (isLocationSharing.value) {
      _startLocationSharing();
    } else {
      _stopLocationSharing();
    }
  }

  void _startLocationSharing() {
    // TODO: Implementar servicio de ubicación
    Get.snackbar(
      'Ubicación Activada',
      'Compartiendo tu ubicación con tus tutores',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _stopLocationSharing() {
    Get.snackbar(
      'Ubicación Desactivada',
      'Ya no compartes tu ubicación',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
