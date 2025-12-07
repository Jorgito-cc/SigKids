import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../widgets/child_avatar.dart';
import '../../widgets/custom_button.dart';

class AsignacionPage extends StatefulWidget {
  const AsignacionPage({Key? key}) : super(key: key);

  @override
  State<AsignacionPage> createState() => _AsignacionPageState();
}

class _AsignacionPageState extends State<AsignacionPage> {
  final List<int> _selectedNinos = [];
  int? _selectedAreaId;
  bool _isLoading = false;

  // Datos estáticos
  final List<Map<String, dynamic>> _areas = [
    {'id': 1, 'nombre': 'Casa'},
    {'id': 2, 'nombre': 'Escuela'},
    {'id': 3, 'nombre': 'Parque'},
  ];

  final List<Map<String, dynamic>> _ninos = [
    {'id': 1, 'nombre': 'Emma García', 'edad': 8},
    {'id': 2, 'nombre': 'Lucas Rodríguez', 'edad': 10},
    {'id': 3, 'nombre': 'Sophia Martínez', 'edad': 7},
    {'id': 4, 'nombre': 'Oliver López', 'edad': 9},
  ];

  @override
  void initState() {
    super.initState();
    final area = Get.arguments as Map<String, dynamic>?;
    if (area != null) {
      _selectedAreaId = area['id'];
    }
  }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: _buildAreaSelector(),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: const Text(
                          'Selecciona los niños',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._ninos.asMap().entries.map((entry) {
                        return FadeInUp(
                          delay:
                              Duration(milliseconds: 300 + (entry.key * 100)),
                          child: _buildNinoCheckbox(entry.value),
                        );
                      }).toList(),
                      const SizedBox(height: 30),
                      FadeInUp(
                        delay: const Duration(milliseconds: 700),
                        child: CustomButton(
                          text: 'Asignar',
                          onPressed: _handleAssign,
                          isLoading: _isLoading,
                          icon: Icons.check,
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
            'Asignar a Área',
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

  Widget _buildAreaSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedAreaId,
          hint: const Text(
            'Selecciona un área',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          isExpanded: true,
          dropdownColor: AppTheme.surfaceColor,
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          items: _areas.map((area) {
            return DropdownMenuItem<int>(
              value: area['id'],
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    area['nombre'],
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedAreaId = value);
          },
        ),
      ),
    );
  }

  Widget _buildNinoCheckbox(Map<String, dynamic> nino) {
    final isSelected = _selectedNinos.contains(nino['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedNinos.add(nino['id']);
            } else {
              _selectedNinos.remove(nino['id']);
            }
          });
        },
        title: Text(
          nino['nombre'],
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${nino['edad']} años',
          style: TextStyle(
            color: AppTheme.textSecondary.withOpacity(0.8),
          ),
        ),
        secondary: ChildAvatar(
          name: nino['nombre'],
          size: 50,
        ),
        activeColor: AppTheme.primaryColor,
        checkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _handleAssign() {
    if (_selectedAreaId == null) {
      Get.snackbar(
        'Error',
        'Selecciona un área',
        backgroundColor: AppTheme.dangerColor,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedNinos.isEmpty) {
      Get.snackbar(
        'Error',
        'Selecciona al menos un niño',
        backgroundColor: AppTheme.dangerColor,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      Get.back();
      Get.snackbar(
        'Asignado',
        '${_selectedNinos.length} niño(s) asignado(s) correctamente',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }
}
