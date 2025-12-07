import 'package:get/get.dart';
import '../controllers/nino_controller.dart';

class NinoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NinoController>(() => NinoController());
  }
}
