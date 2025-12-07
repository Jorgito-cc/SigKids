import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../widgets/child_avatar.dart';
import '../../../routes/app_routes.dart';

class NinoListPage extends StatelessWidget {
  const NinoListPage({Key? key}) : super(key: key);

  // Datos estáticos de ejemplo
  static final List<Map<String, dynamic>> _ninosEstaticos = [
    {
      'id': 1,
      'nombre': 'Emma García',
      'edad': 8,
      'telefono': '+598 91 234 567',
      'isOnline': true,
      'isInsideArea': true,
    },
    {
      'id': 2,
      'nombre': 'Lucas Rodríguez',
      'edad': 10,
      'telefono': '+598 92 345 678',
      'isOnline': true,
      'isInsideArea': false,
    },
    {
      'id': 3,
      'nombre': 'Sophia Martínez',
      'edad': 7,
      'telefono': '+598 93 456 789',
      'isOnline': true,
      'isInsideArea': true,
    },
    {
      'id': 4,
      'nombre': 'Oliver López',
      'edad': 9,
      'telefono': '+598 94 567 890',
      'isOnline': false,
      'isInsideArea': true,
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
                  itemCount: _ninosEstaticos.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: _buildNinoCard(_ninosEstaticos[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.ninoCreate),
          backgroundColor: AppTheme.primaryColor,
          icon: const Icon(Icons.add),
          label: const Text('Agregar Niño'),
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
            'Mis Niños',
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

  Widget _buildNinoCard(Map<String, dynamic> nino) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          ChildAvatar(
            name: nino['nombre'],
            isOnline: nino['isOnline'],
            isInsideArea: nino['isInsideArea'],
            size: 60,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nino['nombre'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${nino['edad']} años',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: AppTheme.textSecondary.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      nino['telefono'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppTheme.primaryColor),
                onPressed: () =>
                    Get.toNamed(AppRoutes.ninoEdit, arguments: nino),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: AppTheme.dangerColor),
                onPressed: () => _showDeleteDialog(nino),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> nino) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Eliminar niño?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          '¿Estás seguro de eliminar a ${nino['nombre']}?',
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
                '${nino['nombre']} ha sido eliminado',
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
