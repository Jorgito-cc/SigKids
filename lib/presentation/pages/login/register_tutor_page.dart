import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class RegisterTutorPage extends GetView<LoginController> {
  const RegisterTutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurarse de que el modo registro y rol tutor estén activos
    controller.isRegister.value = true;
    controller.isTutor.value = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Tutor'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(Icons.person_add,
                        size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  CustomInput(
                    label: "Nombre",
                    controller: controller.name,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: "Apellido",
                    controller: controller.lastname,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: "Cédula",
                    controller: controller.ci,
                    prefixIcon: Icons.badge,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: "Fecha de nacimiento",
                    controller: controller.birth,
                    readOnly: true,
                    prefixIcon: Icons.calendar_today,
                    onTap: () => controller.pickBirthDate(context),
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: "Dirección",
                    controller: controller.address,
                    prefixIcon: Icons.home,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    label: "Email",
                    controller: controller.email,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => CustomInput(
                        label: "Contraseña",
                        controller: controller.password,
                        obscureText: controller.obscure.value,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey),
                          onPressed: controller.togglePassword,
                        ),
                      )),
                  const SizedBox(height: 40),
                  Obx(() => CustomButton(
                        text: "Completar Registro",
                        isLoading: controller.loading.value,
                        onPressed: () {
                          // Validación básica
                          if (controller.name.text.trim().isEmpty ||
                              controller.lastname.text.trim().isEmpty ||
                              controller.ci.text.trim().isEmpty ||
                              controller.birth.text.trim().isEmpty ||
                              controller.address.text.trim().isEmpty ||
                              controller.email.text.trim().isEmpty ||
                              controller.password.text.trim().isEmpty) {
                            Get.snackbar(
                              "Campos incompletos",
                              "Por favor completa todos los campos",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          print("====================================");
                          print("🟢 REGISTRO TUTOR — DATOS DEL FORM");
                          print("👤 Nombre: ${controller.name.text}");
                          print("👤 Apellido: ${controller.lastname.text}");
                          print("🪪 CI: ${controller.ci.text}");
                          print("🎂 Fecha Nac: ${controller.birth.text}");
                          print("🏠 Dirección: ${controller.address.text}");
                          print("📧 Email: ${controller.email.text}");
                          print("🔑 Password: ${controller.password.text}");
                          print("====================================");

                          controller.register();
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
