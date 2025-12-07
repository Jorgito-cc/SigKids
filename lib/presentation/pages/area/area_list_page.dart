import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../../routes/app_routes.dart';

class AreaListPage extends StatelessWidget {
  const AreaListPage({Key? key}) : super(key: key);

  // Datos estáticos de ejemplo
  static final List<Map<String, dynamic>> _areasEstaticas = [
    {
      'id': 1,
      'nombre': 'Casa',
      'estado': 'ACTIVO',
      'ninosAsignados': 3,
      'vertices': 4,
    },
    {
      'id': 2,
      'nombre': 'Escuela',
      'estado': 'ACTIVO',
      'ninosAsignados': 2,
      'vertices': 5,
    },
    {
      'id': 3,
      'nombre': 'Parque',
      'estado': 'INACTIVO',
      'ninosAsignados': 1,
      'vertices': 6,
    },
  ];

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
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: _areasEstaticas.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: _buildAreaCard(_areasEstaticas[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 400),
        child: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.areaCreate),
          backgroundColor: AppTheme.successColor,
          icon: const Icon(Icons.add_location),
          label: const Text('Crear Área'),
        ),
      ),
    );
  }

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
            'Áreas de Monitoreo',
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

  Widget _buildAreaCard(Map<String, dynamic> area) {
    final isActive = area['estado'] == 'ACTIVO';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isActive
                          ? AppTheme.successColor
                          : AppTheme.textSecondary)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color:
                      isActive ? AppTheme.successColor : AppTheme.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area['nombre'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (isActive
                                    ? AppTheme.successColor
                                    : AppTheme.textSecondary)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            area['estado'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: AppTheme.textPrimary),
                color: AppTheme.surfaceColor,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: AppTheme.primaryColor),
                        SizedBox(width: 12),
                        Text('Editar',
                            style: TextStyle(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(Icons.toggle_on, color: AppTheme.accentColor),
                        SizedBox(width: 12),
                        Text('Activar/Desactivar',
                            style: TextStyle(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppTheme.dangerColor),
                        SizedBox(width: 12),
                        Text('Eliminar',
                            style: TextStyle(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Get.toNamed(AppRoutes.areaEdit, arguments: area);
                  } else if (value == 'toggle') {
                    Get.snackbar(
                      'Estado cambiado',
                      'El área ha sido ${isActive ? "desactivada" : "activada"}',
                      backgroundColor: AppTheme.accentColor,
                      colorText: Colors.white,
                    );
                  } else if (value == 'delete') {
                    _showDeleteDialog(area);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.textSecondary, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.child_care,
                  label: 'Niños',
                  value: '${area['ninosAsignados']}',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.pentagon_outlined,
                  label: 'Vértices',
                  value: '${area['vertices']}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Get.toNamed(AppRoutes.asignacion, arguments: area),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Asignar Niños'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withOpacity(0.6),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteDialog(Map<String, dynamic> area) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Eliminar área?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          '¿Estás seguro de eliminar el área "${area['nombre']}"?',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Eliminado',
                'El área "${area['nombre']}" ha sido eliminada',
                backgroundColor: AppTheme.dangerColor,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }
}
