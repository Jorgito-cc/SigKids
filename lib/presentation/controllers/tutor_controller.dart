import 'package:get/get.dart';
import '../../api/tutor_api.dart';
import '../../config/local_storage.dart';
import '../../models/tutor_model.dart';

class TutorController extends GetxController {
  var tutor = Rxn<TutorModel>();
  var loading = true.obs;

  final storage = LocalStorage();

  late int tutorId;

  @override
  void onInit() {
    super.onInit();
    tutorId = storage.getUserId() ?? 0;
    loadTutor();
  }

  Future<void> loadTutor() async {
    loading.value = true;
    try {
      tutor.value = await TutorApi.getTutor(tutorId);
    } finally {
      loading.value = false;
    }
  }

  Future<void> addHijo(String email) async {
    loading.value = true;
    try {
      tutor.value = await TutorApi.addHijo(tutorId, email);
      Get.snackbar("Éxito", "Hijo agregado correctamente");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeHijo(int hijoId) async {
    loading.value = true;
    try {
      tutor.value = await TutorApi.removeHijo(tutorId, hijoId);
      Get.snackbar("Éxito", "Hijo eliminado");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }
}
