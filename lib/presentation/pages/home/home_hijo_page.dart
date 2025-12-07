import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/home_hijo_controller.dart';

class HomeHijoPage extends GetView<HomeHijoController> {
  const HomeHijoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Obx(() => Text(
                            controller.hijoNombre.value,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => Get.toNamed(AppRoutes.perfil),
                  ),
                ],
              ),

              // Estado de Ubicación
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    child: Obx(() => Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: controller.isLocationSharing.value
                                ? AppTheme.successGradient
                                : AppTheme.dangerGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.glowShadow,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                controller.isLocationSharing.value
                                    ? Icons.location_on
                                    : Icons.location_off,
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.isLocationSharing.value
                                    ? 'Ubicación Compartida'
                                    : 'Ubicación Desactivada',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.isLocationSharing.value
                                    ? 'Tus tutores pueden ver tu ubicación'
                                    : 'Activa para compartir tu ubicación',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: controller.toggleLocationSharing,
                                icon: Icon(
                                  controller.isLocationSharing.value
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                ),
                                label: Text(
                                  controller.isLocationSharing.value
                                      ? 'Detener'
                                      : 'Activar',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      controller.isLocationSharing.value
                                          ? AppTheme.successColor
                                          : AppTheme.dangerColor,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),

              // Mis Tutores
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Tutores',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (controller.tutores.isEmpty) {
                            return _buildEmptyState(
                              context,
                              'No tienes tutores asignados',
                              Icons.people,
                            );
                          }

                          return Column(
                            children: controller.tutores
                                .map((tutor) => _buildTutorCard(context, tutor))
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Mis Áreas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Áreas de Seguridad',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.areas.isEmpty) {
                            return _buildEmptyState(
                              context,
                              'No estás asignado a ningún área',
                              Icons.location_city,
                            );
                          }

                          return Column(
                            children: controller.areas
                                .map((area) => _buildAreaCard(context, area))
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.map),
        label: const Text('Ver Mapa'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  Widget _buildTutorCard(BuildContext context, Map<String, dynamic> tutor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              tutor['nombre'][0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tutor['nombre']} ${tutor['apellido']}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  tutor['rol'] ?? 'Tutor',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            color: AppTheme.successColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAreaCard(BuildContext context, Map<String, dynamic> area) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area['nombre'] ?? 'Área',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Activa',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successColor,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
