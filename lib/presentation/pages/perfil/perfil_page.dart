import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_theme.dart';
import '../../controllers/login_controller.dart';

class PerfilPage extends GetView<LoginController> {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // -------- AVATAR --------
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          controller.name.text.isNotEmpty
                              ? controller.name.text[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------- NOMBRE COMPLETO --------
                      Text(
                        "${controller.name.text} ${controller.lastname.text}",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      // -------- ROL --------
                      Text(
                        controller.isTutor.value ? "Tutor" : "Hijo",
                        style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // -------- INFO CARD --------
                      _buildInfoCard(context, controller),

                      const SizedBox(height: 30),

                      // -------- EDITAR PERFIL --------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Editar Perfil",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------- LOGOUT --------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await controller.logout();
                            Get.offAllNamed("/login");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Cerrar Sesión",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- APP BAR --------
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 12),
          const Text(
            'Mi Perfil',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // -------- TARJETA DE INFORMACIÓN --------
  Widget _buildInfoCard(BuildContext context, LoginController c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoItem(Icons.email, "Correo", c.email.text),
          _infoItem(Icons.phone, "Teléfono", c.phone.text),
          _infoItem(Icons.location_on, "Dirección", c.address.text),
          _infoItem(Icons.cake, "Fecha de nacimiento", c.birth.text),
          _infoItem(Icons.badge, "CI", c.ci.text),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      color: AppTheme.textSecondary.withOpacity(0.7),
                      fontSize: 13,
                    )),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : "Sin datos",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
