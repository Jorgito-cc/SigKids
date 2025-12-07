import 'package:get/get.dart';
import '../../api/auth_api.dart';
import '../../config/local_storage.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final storage = LocalStorage();

  @override
  void onReady() async {
    super.onReady();

    await Future.delayed(const Duration(seconds: 1));

    final token = storage.getToken();

    if (token == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final isValid = await AuthApi.verifyToken();

    if (isValid) {
      Get.offAllNamed(AppRoutes.homeTutor);
    } else {
      storage.clearSession();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
