import 'package:get/get.dart';
import 'app_routes.dart';

// Bindings
import '../presentation/bindings/login_binding.dart';
import '../presentation/bindings/home_binding.dart';
import '../presentation/bindings/home_tutor_binding.dart';
import '../presentation/bindings/home_hijo_binding.dart';
import '../presentation/bindings/nino_binding.dart';
import '../presentation/bindings/area_binding.dart';
import '../presentation/bindings/mapa_binding.dart';

// Pages
import '../presentation/pages/login/login_page.dart';
import '../presentation/pages/login/role_selector_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/home/home_tutor_page.dart';
import '../presentation/pages/home/home_hijo_page.dart';
import '../presentation/pages/nino/nino_list_page.dart';
import '../presentation/pages/nino/nino_form_page.dart';
import '../presentation/pages/area/area_list_page.dart';
import '../presentation/pages/area/area_form_page.dart';
import '../presentation/pages/asignacion/asignacion_page.dart';
import '../presentation/pages/mapa/mapa_page.dart';

/// Configuración de páginas y rutas de la aplicación
class AppPages {
  static final pages = [
    // ========== AUTH ==========
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),

    // Selector de rol (después de login exitoso)
    GetPage(
      name: '/role-selector',
      page: () => const RoleSelectorPage(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),

    // ========== HOME ==========
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),

    GetPage(
      name: AppRoutes.homeTutor,
      page: () => const HomeTutorPage(),
      binding: HomeTutorBinding(),
      transition: Transition.fade,
    ),

    GetPage(
      name: AppRoutes.homeHijo,
      page: () => const HomeHijoPage(),
      binding: HomeHijoBinding(),
      transition: Transition.fade,
    ),

    // ========== NIÑOS ==========
    GetPage(
      name: AppRoutes.ninos,
      page: () => const NinoListPage(),
      binding: NinoBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: AppRoutes.ninoCreate,
      page: () => const NinoFormPage(),
      binding: NinoBinding(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: AppRoutes.ninoEdit,
      page: () => const NinoFormPage(isEdit: true),
      binding: NinoBinding(),
      transition: Transition.rightToLeft,
    ),

    // ========== ÁREAS ==========
    GetPage(
      name: AppRoutes.areas,
      page: () => const AreaListPage(),
      binding: AreaBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: AppRoutes.areaCreate,
      page: () => const AreaFormPage(),
      binding: AreaBinding(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: AppRoutes.areaEdit,
      page: () => const AreaFormPage(isEdit: true),
      binding: AreaBinding(),
      transition: Transition.rightToLeft,
    ),

    // ========== ASIGNACIÓN ==========
    GetPage(
      name: AppRoutes.asignacion,
      page: () => const AsignacionPage(),
      binding: AreaBinding(),
      transition: Transition.cupertino,
    ),

    // ========== MAPA ==========
    GetPage(
      name: AppRoutes.mapa,
      page: () => const MapaPage(),
      binding: MapaBinding(),
      transition: Transition.fade,
    ),

    GetPage(
      name: AppRoutes.mapaMonitoreo,
      page: () => const MapaMonitoreoPage(),
      binding: MapaBinding(),
      transition: Transition.zoom,
    ),

    // ========== OTROS ==========
    GetPage(
      name: AppRoutes.historial,
      page: () => const HistorialPage(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: AppRoutes.perfil,
      page: () => const PerfilPage(),
      transition: Transition.cupertino,
    ),
  ];
}
