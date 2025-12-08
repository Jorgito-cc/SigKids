import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController(), permanent: true);
  }
}
