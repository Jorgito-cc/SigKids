import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/mapa_controller.dart';
import '../../../config/app_theme.dart';

class AreaMapPage extends GetView<MapaController> {
  final String tutorId;

  const AreaMapPage({
    super.key,
    required this.tutorId,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cancelar edición si volvemos atrás
        if (controller.isEditingMode.value) {
          controller.exitEditMode();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Área de Monitoreo'),
          elevation: 0,
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Obx(
          () => Stack(
            children: [
              // Mapa
              _buildMap(),

              // Overlay de instrucciones
              if (controller.isEditingMode.value) _buildInstructionsOverlay(),

              // Indicador de vértices
              if (controller.isEditingMode.value) _buildVertexCounter(),

              // Controles inferiores
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== MAPA ====================

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target:
            controller.cameraLocation.value ?? const LatLng(37.7749, -122.4194),
        zoom: 15,
      ),
      onMapCreated: (mapCtrl) {
        controller.mapController = mapCtrl;
      },
      onTap: controller.isEditingMode.value
          ? (LatLng latLng) => controller.addVertex(latLng)
          : null,
      polylines: {
        // Dibujar polígono
        if (controller.areaVertices.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('area_polygon'),
            points: [
              ...controller.areaVertices,
              if (controller.areaVertices.isNotEmpty)
                controller.areaVertices.first, // Cerrar polígono
            ],
            color: AppTheme.primaryColor,
            width: 3,
            geodesic: true,
          ),
      },
      markers: {
        // Marcadores en vértices
        ...controller.areaVertices.asMap().entries.map(
              (entry) => Marker(
                markerId: MarkerId('vertex_${entry.key}'),
                position: entry.value,
                infoWindow: InfoWindow(
                  title: 'Vértice ${entry.key + 1}',
                  snippet: '${entry.value.latitude.toStringAsFixed(4)}, '
                      '${entry.value.longitude.toStringAsFixed(4)}',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              ),
            ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  // ==================== OVERLAY DE INSTRUCCIONES ====================

  Widget _buildInstructionsOverlay() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Toca el mapa para agregar vértices (mín. 3)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Vértices: ${controller.areaVertices.length}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== CONTADOR DE VÉRTICES ====================

  Widget _buildVertexCounter() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${controller.areaVertices.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'vértices',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== CONTROLES INFERIORES ====================

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isEditingMode.value
              ? _buildEditingControls()
              : _buildNormalControls(),
        ),
      ),
    );
  }

  // Controles cuando NO está editando
  Widget _buildNormalControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('✏️ Dibujar Nueva Área'),
          onPressed: () => controller.enterEditMode(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // Controles cuando SÍ está editando
  Widget _buildEditingControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nombre del área
            TextField(
              decoration: InputDecoration(
                hintText: 'Nombre del área (ej: Parque Central)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // Guardar nombre en variable temporal
              },
            ),
            const SizedBox(height: 12),

            // Botones de acción
            Row(
              children: [
                // Botón deshacer
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.undo),
                    label: const Text('Deshacer'),
                    onPressed: controller.areaVertices.isEmpty
                        ? null
                        : () => controller.undoLastVertex(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón guardar
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    onPressed: controller.areaVertices.length >= 3
                        ? () => _saveArea()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón cancelar
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    onPressed: () => controller.exitEditMode(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== LÓGICA ====================

  Future<void> _saveArea() async {
    final nameCtrl = TextEditingController();

    // Mostrar diálogo para nombre del área
    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Nombre del Área'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            hintText: 'Ej: Parque Central',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: nameCtrl.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    // Guardar el área
    await controller.saveArea(
      nombreArea: result,
      tutorId: tutorId,
    );

    if (Get.context != null && Get.context!.mounted) {
      Get.back();
    }
  }
}
