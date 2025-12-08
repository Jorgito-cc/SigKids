import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../config/app_theme.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/home_tutor_controller.dart';

class AsignarHijoPage extends StatefulWidget {
  const AsignarHijoPage({super.key});

  @override
  State<AsignarHijoPage> createState() => _AsignarHijoPageState();
}

class _AsignarHijoPageState extends State<AsignarHijoPage> {
  final emailController = TextEditingController();
  final loginController = Get.find<LoginController>();

  bool loading = false;

  Future<void> asignarHijo() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Por favor ingresa el correo del hijo",
        backgroundColor: Colors.red,
        colorText: Colors.white, // ⭐ Texto blanco mejor legible
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final tutorId = await loginController.userId;
      final token = await loginController.token;

      final resp = await loginController.dioClient.post(
        "/tutor/$tutorId/hijos",
        data: {
          "hijo_email": emailController.text.trim(),
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      Get.snackbar(
        "Éxito",
        "Hijo asignado correctamente",
        backgroundColor: Colors.green,
        colorText: Colors.white, // ⭐ Texto blanco
      );

      emailController.clear();

      try {
        final homeTutorController = Get.find<HomeTutorController>();
        homeTutorController.refresh();
      } catch (e) {
        print("⚠️ HomeTutorController not found, skipping refresh");
      }

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "No se pudo asignar el hijo. Verifica que el correo sea correcto.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white, // ⭐ Texto blanco
      );
      print("❌ Error: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Asignar Hijo",
          style: TextStyle(color: Colors.white), // ⭐ Texto blanco
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white), // ⭐ Flecha blanca
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // ⭐ TextField con colores mejorados
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white), // ⭐ Texto blanco

                decoration: InputDecoration(
                  labelText: "Correo del hijo",
                  labelStyle: const TextStyle(color: Colors.white), // ⭐ Label blanco

                  hintText: "ejemplo@correo.com",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // ⭐ Hint más tenue

                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1), // ⭐ Fondo semitransparente

                  prefixIcon: const Icon(Icons.email, color: Colors.white), // ⭐ Icono blanco

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ⭐ Botón mejorado
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : asignarHijo,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white, // ⭐ Texto del botón blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Asignar Hijo",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
