import 'package:get/get.dart';
import '../controllers/home_hijo_controller.dart';

class HomeHijoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeHijoController>(() => HomeHijoController());
  }
}
