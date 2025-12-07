import 'package:get/get.dart';
import '../../api/tutor_api.dart';
import '../../config/local_storage.dart';

class HomeTutorController extends GetxController {
  final TutorApi _tutorApi = TutorApi();
  final LocalStorage _storage = LocalStorage();

  final isLoading = false.obs;
  final tutorNombre = ''.obs;
  final totalHijos = 0.obs;
  final totalAreas = 0.obs;
  final hijos = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTutorData();
    _loadHijos();
  }

  void _loadTutorData() {
    final tutorData = _storage.getTutor();
    if (tutorData != null) {
      tutorNombre.value = '${tutorData['nombre']} ${tutorData['apellido']}';
    }
  }

  Future<void> _loadHijos() async {
    try {
      isLoading.value = true;

      final tutorData = _storage.getTutor();
      if (tutorData == null) return;

      final tutorId = tutorData['id'] as int;
      final tutorWithHijos = await _tutorApi.getTutorWithHijos(tutorId);

      final hijosList = tutorWithHijos['hijos'] as List?;
      if (hijosList != null) {
        hijos.value = hijosList.cast<Map<String, dynamic>>();
        totalHijos.value = hijosList.length;
      }
    } catch (e) {
      print('Error cargando hijos: $e');
      Get.snackbar('Error', 'No se pudieron cargar los hijos');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    _loadHijos();
  }
}
