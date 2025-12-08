import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/home_tutor_controller.dart';

class HomeTutorPage extends GetView<HomeTutorController> {
  const HomeTutorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("📄 HomeTutorPage → build()");
    print("👤 Tutor actual: ${controller.tutorNombre.value}");
    print("👶 Total hijos: ${controller.totalHijos.value}");
    print("📍 Total áreas: ${controller.totalAreas.value}");

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
                        '¡Hola Tutor!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Obx(() {
                        print("🔄 Actualizando nombre tutor: ${controller.tutorNombre.value}");
                        return Text(
                          controller.tutorNombre.value,
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      print("🔔 PRESIONADO → Notificaciones");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () {
                      print("👤 PRESIONADO → Perfil");
                      Get.toNamed(AppRoutes.perfil);
                    },
                  ),
                ],
              ),

              // Estadísticas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          print("📊 Render estadisticas → Hijos: ${controller.totalHijos.value}, Áreas: ${controller.totalAreas.value}");
                          return Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  'Hijos',
                                  controller.totalHijos.value.toString(),
                                  Icons.child_care,
                                  AppTheme.primaryGradient,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  'Áreas',
                                  controller.totalAreas.value.toString(),
                                  Icons.location_on,
                                  AppTheme.successGradient,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Acciones Rápidas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Acciones Rápidas',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionCard(
                                context,
                                'Agregar Hijo',
                                Icons.person_add,
                                AppTheme.primaryColor,
                                () {
                                  print("➕ Acción rápida → Agregar Hijo");
                                  Get.toNamed(AppRoutes.asignarHijo);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionCard(
                                context,
                                'Crear Área',
                                Icons.add_location,
                                AppTheme.successColor,
                                () {
                                  print("📍 Acción rápida → Crear Área");
                                  Get.toNamed(AppRoutes.areaCreate);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionCard(
                                context,
                                'Monitoreo',
                                Icons.map,
                                AppTheme.accentColor,
                                () {
                                  print("🛰️ Acción rápida → Monitoreo");
                                  Get.toNamed(AppRoutes.mapaMonitoreo);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionCard(
                                context,
                                'Historial',
                                Icons.history,
                                AppTheme.warningColor,
                                () {
                                  print("📜 Acción rápida → Historial");
                                  Get.toNamed(AppRoutes.historial);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Lista de Hijos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mis Hijos',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                print("👶 PRESIONADO → Ver todos los hijos");
                                Get.toNamed(AppRoutes.ninos);
                              },
                              child: const Text('Ver todos'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          print("🔄 Actualizando lista de hijos…");
                          
                          if (controller.isLoading.value) {
                            print("⏳ Cargando hijos…");
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (controller.hijos.isEmpty) {
                            print("⚠️ No hay hijos registrados");
                            return _buildEmptyState(context);
                          }

                          print("📋 Renderizando hijos (máximo 3) → ${controller.hijos.length}");

                          return Column(
                            children: controller.hijos
                                .take(3)
                                .map((hijo) {
                                  print("👦 Render hijo: $hijo");
                                  return _buildHijoCard(context, hijo);
                                })
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
        onPressed: () {
          print("🛰️ FAB → Monitoreo GPS");
          Get.toNamed(AppRoutes.mapaMonitoreo);
        },
        icon: const Icon(Icons.map),
        label: const Text('Monitoreo'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Gradient gradient,
  ) {
    print("📦 Construyendo StatCard → $label : $value");

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    print("🎯 Render ActionCard → $label");

    return InkWell(
      onTap: () {
        print("👆 PRESIONADO → $label");
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHijoCard(BuildContext context, Map<String, dynamic> hijo) {
    print("🧩 Construyendo tarjeta de hijo: ${hijo['nombre']}");

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
              hijo['nombre'][0].toUpperCase(),
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
                  '${hijo['nombre']} ${hijo['apellido']}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successColor,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            color: AppTheme.accentColor,
            onPressed: () {
              print("📍 Ver ubicación de hijo: ${hijo['nombre']}");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    print("📭 Renderizando empty state (sin hijos)");

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.child_care,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes hijos registrados',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer hijo para comenzar',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
