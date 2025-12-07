import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../../config/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class NinoFormPage extends StatefulWidget {
  final bool isEdit;

  const NinoFormPage({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<NinoFormPage> createState() => _NinoFormPageState();
}

class _NinoFormPageState extends State<NinoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      final nino = Get.arguments as Map<String, dynamic>?;
      if (nino != null) {
        _nombreController.text = nino['nombre']?.split(' ')[0] ?? '';
        _apellidoController.text =
            nino['nombre']?.split(' ').skip(1).join(' ') ?? '';
        _telefonoController.text = nino['telefono'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FadeInDown(
                          child: _buildAvatarSection(),
                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: CustomInput(
                            label: 'Nombre',
                            hint: 'Nombre del niño',
                            controller: _nombreController,
                            prefixIcon: Icons.person_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el nombre';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: CustomInput(
                            label: 'Apellido',
                            hint: 'Apellido del niño',
                            controller: _apellidoController,
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el apellido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: CustomInput(
                            label: 'Fecha de Nacimiento',
                            hint: 'DD/MM/AAAA',
                            controller: _fechaNacimientoController,
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Selecciona la fecha de nacimiento';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 500),
                          child: CustomInput(
                            label: 'Teléfono',
                            hint: '+598 XX XXX XXX',
                            controller: _telefonoController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el teléfono';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeInUp(
                          delay: const Duration(milliseconds: 600),
                          child: CustomInput(
                            label: 'Dirección',
                            hint: 'Dirección del niño',
                            controller: _direccionController,
                            prefixIcon: Icons.home_outlined,
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa la dirección';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeInUp(
                          delay: const Duration(milliseconds: 700),
                          child: CustomButton(
                            text: widget.isEdit ? 'Actualizar' : 'Guardar',
                            onPressed: _handleSubmit,
                            isLoading: _isLoading,
                            icon: widget.isEdit ? Icons.save : Icons.add,
                          ),
                        ),
                      ],
                    ),
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
            widget.isEdit ? 'Editar Niño' : 'Agregar Niño',
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

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
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
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.backgroundColor,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              surface: AppTheme.surfaceColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular guardado
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Get.back();
        Get.snackbar(
          widget.isEdit ? 'Actualizado' : 'Guardado',
          'El niño ha sido ${widget.isEdit ? 'actualizado' : 'guardado'} correctamente',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      });
    }
  }
}
