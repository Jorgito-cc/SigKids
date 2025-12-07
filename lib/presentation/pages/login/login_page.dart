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
    debugPrint(
        '[LoginPage] Building LoginPage... Controller: ${controller.runtimeType}');

    // Inicializar modo si viene de registro
    if (isRegister) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.isRegisterMode.value = true;
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo animado
                    _buildLogo(),

                    const SizedBox(height: 40),

                    // Título
                    _buildTitle(),

                    const SizedBox(height: 40),

                    // Formulario
                    if (controller.isRegisterMode.value)
                      _buildRegisterForm(context)
                    else
                      _buildLoginForm(),

                    const SizedBox(height: 24),

                    // Botón principal
                    _buildMainButton(),

                    const SizedBox(height: 24),

                    // Toggle entre login y registro
                    _buildToggleButton(),

                    const SizedBox(height: 40),
                  ],
                )),
          ),
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
          child: const Icon(
            Icons.child_care,
            size: 60,
            color: Colors.white,
          ),
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
                controller.isRegisterMode.value ? 'Registro' : 'Bienvenido',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'SIGKids – Monitoreo Infantil',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
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
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          Obx(() => CustomInput(
                label: 'Contraseña',
                hint: '••••••••',
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                prefixIcon: Icons.lock_outlined,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
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
            label: 'Nombre',
            hint: 'Tu nombre',
            controller: controller.nombreController,
            prefixIcon: Icons.person_outlined,
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Apellido',
            hint: 'Tu apellido',
            controller: controller.apellidoController,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Cédula de Identidad',
            hint: '12345678',
            controller: controller.ciController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Fecha de Nacimiento',
            hint: 'DD/MM/AAAA',
            controller: controller.fechaNacimientoController,
            readOnly: true,
            prefixIcon: Icons.calendar_today_outlined,
            onTap: () => controller.selectFechaNacimiento(context),
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Dirección',
            hint: 'Tu dirección',
            controller: controller.direccionController,
            prefixIcon: Icons.home_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          CustomInput(
            label: 'Email',
            hint: 'tu@email.com',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          Obx(() => CustomInput(
                label: 'Contraseña',
                hint: '••••••••',
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                prefixIcon: Icons.lock_outlined,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Obx(() => FadeInUp(
          delay: const Duration(milliseconds: 600),
          child: CustomButton(
            text: controller.isRegisterMode.value
                ? 'Registrarse'
                : 'Iniciar Sesión',
            onPressed: controller.isRegisterMode.value
                ? controller.register
                : controller.login,
            isLoading: controller.isLoading.value,
            icon: controller.isRegisterMode.value
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
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: controller.isRegisterMode.value
                        ? '¿Ya tienes cuenta? '
                        : '¿No tienes cuenta? ',
                  ),
                  TextSpan(
                    text: controller.isRegisterMode.value
                        ? 'Iniciar Sesión'
                        : 'Regístrate',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
