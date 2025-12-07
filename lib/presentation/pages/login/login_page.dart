import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smart_sig/presentation/controllers/login_controller.dart';
import '../../../config/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class LoginPage extends GetView<LoginController> {
  final bool isRegister;

  const LoginPage({Key? key, this.isRegister = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRegister) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.isRegister.value = true;
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Obx(() => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    _buildLogo(),
                    const SizedBox(height: 40),
                    _buildTitle(),
                    const SizedBox(height: 40),

                    controller.isRegister.value
                        ? _buildRegisterForm(context)
                        : _buildLoginForm(),

                    const SizedBox(height: 24),
                    _buildMainButton(),
                    const SizedBox(height: 24),
                    _buildToggleButton(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.glowShadow,
          ),
          child: const Icon(Icons.child_care, size: 60, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Obx(() => FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Text(
                controller.isRegister.value ? 'Registro' : 'Bienvenido',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'SIGKids – Monitoreo Infantil',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLoginForm() {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        children: [
          CustomInput(
            label: 'Email',
            hint: 'tu@email.com',
            controller: controller.email,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          Obx(() => CustomInput(
                label: 'Contraseña',
                hint: '••••••••',
                controller: controller.password,
                obscureText: true,
                prefixIcon: Icons.lock_outlined,
              )),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        children: [
          CustomInput(
            label: 'Email',
            hint: 'tu@email.com',
            controller: controller.email,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Contraseña',
            hint: '••••••••',
            controller: controller.password,
            obscureText: true,
            prefixIcon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Obx(() => FadeInUp(
          delay: const Duration(milliseconds: 600),
          child: CustomButton(
            text: controller.isRegister.value
                ? 'Registrarse'
                : 'Iniciar Sesión',
            onPressed: controller.isRegister.value
                ? controller.register
                : controller.login,
            isLoading: controller.isLoading.value,
            icon: controller.isRegister.value
                ? Icons.person_add
                : Icons.login,
          ),
        ));
  }

  Widget _buildToggleButton() {
    return Obx(() => FadeInUp(
          delay: const Duration(milliseconds: 800),
          child: TextButton(
            onPressed: controller.toggleMode,
            child: Text(
              controller.isRegister.value
                  ? '¿Ya tienes cuenta? Inicia sesión'
                  : '¿No tienes cuenta? Regístrate',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}

