import 'package:get/get.dart';
import '../controllers/area_controller.dart';

class AreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AreaController>(() => AreaController());
  }
}
