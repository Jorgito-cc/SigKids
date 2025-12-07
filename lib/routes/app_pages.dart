import 'package:get/get.dart';
import 'app_routes.dart';
import '../presentation/bindings/login_binding.dart';
import '../presentation/pages/login/login_page.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/bindings/home_tutor_binding.dart';
import '../presentation/pages/home/home_tutor_page.dart';
import '../presentation/bindings/home_hijo_binding.dart';
import '../presentation/pages/home/home_hijo_page.dart';

class AppPages {
  static final pages = [
    // LOGIN (primera pantalla)
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // REGISTRO → usa la misma página pero modo registro
    GetPage(
      name: AppRoutes.register,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // HOME
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.homeTutor,
      page: () => const HomeTutorPage(),
      binding: HomeTutorBinding(),
    ),

    GetPage(
      name: AppRoutes.homeHijo,
      page: () => const HomeHijoPage(),
      binding: HomeHijoBinding(),
    ),
  ];
}
