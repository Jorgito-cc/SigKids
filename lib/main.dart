import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'api/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar GetStorage
  await GetStorage.init();

  // Inicializar API Client
  ApiClient().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIGKids - Monitoreo Infantil',

      // Tema
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // 🚀 ESTA ES LA RUTA INICIAL CORRECTA
      initialRoute: AppRoutes.splash,

      // Páginas GetX
      getPages: AppPages.pages,

      // Config extra
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('es', 'ES'),
    );
  }
}
