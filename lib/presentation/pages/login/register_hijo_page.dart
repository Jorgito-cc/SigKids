import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import '../../../config/app_theme.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';
class RegisterHijoPage extends GetView<LoginController> {
  const RegisterHijoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Activar modo Hijo
    controller.isRegister.value = true;
    controller.isTutor.value = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro Hijo"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.secondaryColor),
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
                  // Avatar hijo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.secondaryColor,
                    ),
                    child: const Icon(Icons.child_care,
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
                    label: "Fecha de nacimiento",
                    controller: controller.birth,
                    readOnly: true,
                    prefixIcon: Icons.calendar_today,
                    onTap: () {
                      controller.pickBirthDate(context);
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomInput(
                    label: "Dirección",
                    controller: controller.address,
                    prefixIcon: Icons.home,
                  ),
                  const SizedBox(height: 20),

                  CustomInput(
                    label: "Teléfono (Opcional)",
                    controller: controller.phone,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  CustomInput(
                    label: "Email",
                    controller: controller.email,
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => CustomInput(
                      label: "Contraseña",
                      controller: controller.password,
                      obscureText: controller.obscure.value,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botón Registrar — igual que Tutor
                  Obx(
                    () => CustomButton(
                      text: "Completar Registro",
                      onPressed: () {
                        // Validación básica
                        if (controller.name.text.trim().isEmpty ||
                            controller.lastname.text.trim().isEmpty ||
                            controller.birth.text.trim().isEmpty ||
                            controller.address.text.trim().isEmpty ||
                            controller.email.text.trim().isEmpty ||
                            controller.password.text.trim().isEmpty) {
                          Get.snackbar(
                            "Campos incompletos",
                            "Por favor completa todos los campos obligatorios",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        controller.register();
                      },
                      isLoading: controller.loading.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
