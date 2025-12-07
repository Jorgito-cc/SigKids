import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../widgets/custom_button.dart';

class AreaFormPage extends StatefulWidget {
  final bool isEdit;

  const AreaFormPage({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<AreaFormPage> createState() => _AreaFormPageState();
}

class _AreaFormPageState extends State<AreaFormPage> {
  final _nombreController = TextEditingController();
  bool _isLoading = false;
  final List<Map<String, double>> _vertices = [];

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
                      FadeInDown(
                        child: _buildMapPlaceholder(),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        child: _buildNameInput(),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: _buildInstructions(),
                      ),
                      const SizedBox(height: 30),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: CustomButton(
                          text:
                              widget.isEdit ? 'Actualizar Área' : 'Crear Área',
                          onPressed: _handleSubmit,
                          isLoading: _isLoading,
                          icon: Icons.save,
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
          Text(
            widget.isEdit ? 'Editar Área' : 'Crear Área',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 80,
                  color: AppTheme.textSecondary.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mapa de Google Maps',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca para dibujar el polígono',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Vértices: ${_vertices.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextField(
      controller: _nombreController,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Nombre del Área',
        hintText: 'Ej: Casa, Escuela, Parque',
        prefixIcon:
            const Icon(Icons.label_outlined, color: AppTheme.primaryColor),
        filled: true,
        fillColor: AppTheme.surfaceColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.infoColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Instrucciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionItem('1. Toca en el mapa para agregar vértices'),
          _buildInstructionItem('2. Mínimo 3 vértices para formar el polígono'),
          _buildInstructionItem('3. Mantén presionado un vértice para moverlo'),
          _buildInstructionItem('4. Toca un vértice dos veces para eliminarlo'),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppTheme.infoColor.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_nombreController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Ingresa el nombre del área',
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
        widget.isEdit ? 'Actualizado' : 'Creado',
        'El área ha sido ${widget.isEdit ? "actualizada" : "creada"} correctamente',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }
}
