import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'api/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  ApiClient().initialize(); // Necesario siempre

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIGKids - Monitoreo Infantil',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      /// 🚀 DIRECTO AL LOGIN
      initialRoute: AppRoutes.login,

      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
