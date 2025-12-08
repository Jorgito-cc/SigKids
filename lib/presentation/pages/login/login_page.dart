import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smart_sig/presentation/controllers/login_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../config/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _logo(),
                const SizedBox(height: 40),
                _title(),
                const SizedBox(height: 40),
                _loginForm(),
                const SizedBox(height: 20),
                _mainButton(),
                const SizedBox(height: 20),
                _registerLink(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return ZoomIn(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.primaryGradient,
        ),
        child: const Icon(Icons.child_care, size: 60, color: Colors.white),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Bienvenido",
      style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _loginForm() {
    return Column(
      children: [
        CustomInput(
          label: "Email",
          controller: controller.email,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        Obx(() => CustomInput(
              label: "Contraseña",
              controller: controller.password,
              obscureText: controller.obscure.value,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                    controller.obscure.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white),
                onPressed: controller.togglePassword,
              ),
            )),
      ],
    );
  }

  Widget _mainButton() {
    return Obx(() => CustomButton(
          text: "Iniciar sesión",
          onPressed: controller.login,
          isLoading: controller.loading.value,
        ));
  }

  Widget _registerLink() {
    return TextButton(
      onPressed: () => Get.toNamed(AppRoutes.roleSelector),
      child: const Text(
        "¿No tienes cuenta? Regístrate",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
