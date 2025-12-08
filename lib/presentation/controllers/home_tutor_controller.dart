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
    print("🔵 HomeTutorController → onInit()");
    _loadTutorData();
    _loadHijos();
  }

  void _loadTutorData() {
    print("📥 Cargando datos del tutor desde LocalStorage...");

    final tutorData = _storage.getTutor();
    print("📦 TutorData recibido: $tutorData");

    if (tutorData != null) {
      final nombreCompleto = '${tutorData['nombre']} ${tutorData['apellido']}';
      tutorNombre.value = nombreCompleto;

      print("✅ Nombre del tutor asignado: $nombreCompleto");
    } else {
      print("⚠️ No se encontró tutor en LocalStorage");
    }
  }

  Future<void> _loadHijos() async {
    print("\n==============================================");
    print("🔵 INICIANDO CARGA DE HIJOS (_loadHijos)");
    print("==============================================");

    try {
      isLoading.value = true;
      print("⏳ isLoading = true");

      final tutorData = _storage.getTutor();
      print("📥 Datos del tutor cargados: $tutorData");

      if (tutorData == null) {
        print("❌ ERROR: No hay tutor guardado en LocalStorage");
        return;
      }

      final tutorId = tutorData['id'] as int;
      print("📌 tutorId detectado: $tutorId");

      print("📤 Solicitando hijos desde API: getTutorWithHijos($tutorId)...");
      final tutorWithHijos = await _tutorApi.getTutorWithHijos(tutorId);
      print("📥 Respuesta completa API: $tutorWithHijos");

      final hijosList = tutorWithHijos['hijos'] as List?;
      print("📦 Lista de hijos obtenida: $hijosList");

      if (hijosList != null) {
        hijos.value = hijosList.cast<Map<String, dynamic>>();
        totalHijos.value = hijosList.length;

        print("✅ Hijos asignados al controlador: ${hijos.length}");
        print("👶 Hijos actuales → ${hijos.value}");
      } else {
        print("⚠️ La API devolvió hijos = null");
      }
    } catch (e) {
      print("❌ ERROR AL CARGAR HIJOS: $e");
      Get.snackbar('Error', 'No se pudieron cargar los hijos');
    } finally {
      isLoading.value = false;
      print("⏳ isLoading = false");
      print("🔚 FIN DE _loadHijos()");
      print("==============================================\n");
    }
  }

  void refresh() {
    print("\n🔄 REFRESH HomeTutorController → recargando hijos...");
    _loadHijos();
  }
}
