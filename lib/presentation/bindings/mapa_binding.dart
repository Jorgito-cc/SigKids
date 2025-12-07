import 'package:get/get.dart';
import '../controllers/mapa_controller.dart';

class MapaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapaController>(() => MapaController());
  }
}
