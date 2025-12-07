import 'package:get/get.dart';
import '../controllers/home_tutor_controller.dart';

class HomeTutorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTutorController>(() => HomeTutorController());
  }
}
