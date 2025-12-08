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
    print("📄 HomeHijoPage → build() INICIADO");
    print("👤 Nombre hijo actual: ${controller.hijoNombre.value}");
    print("🔄 Tutores cargados: ${controller.tutores.length}");
    print("📍 Áreas cargadas: ${controller.areas.length}");

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
                      const Text('¡Hola!'),
                      Obx(() {
                        print("🔁 Render nombre hijo: ${controller.hijoNombre.value}");
                        return Text(
                          controller.hijoNombre.value,
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
                      print("🔔 Click en notificaciones");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () {
                      print("👤 Ir a perfil...");
                      Get.toNamed(AppRoutes.perfil);
                    },
                  ),
                ],
              ),

              // Estado de Ubicación
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInUp(
                    child: Obx(() {
                      print("📍 Estado ubicación → ${controller.isLocationSharing.value}");
                      return Container(
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
                              onPressed: () {
                                print("📍 Toggle ubicación...");
                                controller.toggleLocationSharing();
                              },
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
                      );
                    }),
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
                        const Text('Mis Tutores'),
                        const SizedBox(height: 16),
                        Obx(() {
                          print("🔁 Render lista tutores...");

                          if (controller.isLoading.value) {
                            print("⏳ Cargando tutores...");
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (controller.tutores.isEmpty) {
                            print("📭 No hay tutores asignados");
                            return _buildEmptyState(
                              context,
                              'No tienes tutores asignados',
                              Icons.people,
                            );
                          }

                          print("👨‍🏫 Tutores: ${controller.tutores.length}");
                          return Column(
                            children: controller.tutores
                                .map((tutor) {
                                  print("➡️ Render tutor: $tutor");
                                  return _buildTutorCard(context, tutor);
                                })
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
                        const Text('Mis Áreas de Seguridad'),
                        const SizedBox(height: 16),

                        Obx(() {
                          print("🔁 Render lista áreas...");

                          if (controller.areas.isEmpty) {
                            print("📭 No hay áreas asignadas");
                            return _buildEmptyState(
                              context,
                              'No estás asignado a ningún área',
                              Icons.location_city,
                            );
                          }

                          print("📍 Áreas encontradas: ${controller.areas.length}");
                          return Column(
                            children: controller.areas
                                .map((area) {
                                  print("➡️ Render área: $area");
                                  return _buildAreaCard(context, area);
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
          print("🗺️ Click → Ver Mapa");
        },
        icon: const Icon(Icons.map),
        label: const Text('Ver Mapa'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  // -----------------------------
  // TARJETA TUTOR
  // -----------------------------
  Widget _buildTutorCard(BuildContext context, Map<String, dynamic> tutor) {
    print("🎨 Construyendo tarjeta tutor → $tutor");

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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${tutor['nombre']} ${tutor['apellido']}'),
                Text(tutor['rol'] ?? 'Tutor'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: AppTheme.successColor),
            onPressed: () {
              print("📞 Llamar a tutor ${tutor['nombre']}...");
            },
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // TARJETA ÁREA
  // -----------------------------
  Widget _buildAreaCard(BuildContext context, Map<String, dynamic> area) {
    print("🎨 Construyendo tarjeta área → $area");

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
            child: const Icon(Icons.location_on, color: AppTheme.successColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(area['nombre'] ?? 'Área'),
                const Text('Activa'),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppTheme.successColor),
        ],
      ),
    );
  }

  // -----------------------------
  // ESTADO VACÍO
  // -----------------------------
  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    print("📭 Renderizando estado vacío → $message");

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
