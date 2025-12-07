import 'package:get/get.dart';

class HomeController extends GetxController {}

class NinoController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Aquí cargarías los niños desde la API
  }
}

class AreaController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Aquí cargarías las áreas desde la API
  }
}

class MapaController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Aquí inicializarías el mapa
  }
}
