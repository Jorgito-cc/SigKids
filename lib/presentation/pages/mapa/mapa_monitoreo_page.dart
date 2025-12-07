import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/mapa_controller.dart';
import '../../../config/app_theme.dart';

class MapaMonitoreoPage extends GetView<MapaController> {
  final String ninoId;
  final String areaId;

  const MapaMonitoreoPage({
    super.key,
    required this.ninoId,
    required this.areaId,
  });

  @override
  Widget build(BuildContext context) {
    // Cargar datos cuando se abre
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.loadNino(ninoId);
      await controller.loadArea(areaId);
      await controller.loadLocationHistory(int.tryParse(ninoId) ?? 0);
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.selectedNino.value?.nombre ?? 'Monitoreo',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        actions: [
          // Botón centrar en niño
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => controller.centerMapOnNino(),
            tooltip: 'Centrar en niño',
          ),
          // Botón centrar en área
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => controller.centerMapOnArea(),
            tooltip: 'Centrar en área',
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            // Mapa
            _buildMap(),

            // Indicador de estado
            _buildStatusIndicator(),

            // Información del niño
            _buildNinoInfo(),

            // Controles de monitoreo
            _buildMonitoringControls(),
          ],
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
      polylines: {
        // Polígono del área
        if (controller.areaVertices.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('area_polygon'),
            points: [
              ...controller.areaVertices,
              if (controller.areaVertices.isNotEmpty)
                controller.areaVertices.first,
            ],
            color: Colors.blue,
            width: 2,
            geodesic: true,
          ),

        // Línea del historial
        if (controller.locationHistory.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('history_line'),
            points:
                controller.locationHistory.map((loc) => loc.latLng).toList(),
            color: Colors.grey.withOpacity(0.5),
            width: 1,
            geodesic: true,
          ),
      },
      markers: {
        // Marcadores del historial (puntos pequeños)
        ...controller.locationHistory.asMap().entries.map(
              (entry) => Marker(
                markerId: MarkerId('history_${entry.key}'),
                position: entry.value.latLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: InfoWindow(
                  title: 'Punto ${entry.key + 1}',
                  snippet: entry.value.dateTime.toString(),
                ),
              ),
            ),

        // Marcador actual del niño
        if (controller.ninoLocation.value != null)
          Marker(
            markerId: const MarkerId('nino_location'),
            position: controller.ninoLocation.value!,
            icon: controller.getMarkerColor(),
            infoWindow: InfoWindow(
              title: controller.selectedNino.value?.nombre ?? 'Niño',
              snippet: controller.isNinoInsideArea.value
                  ? '✅ Dentro del área'
                  : '⚠️ Fuera del área',
            ),
          ),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }

  // ==================== INDICADOR DE ESTADO ====================

  Widget _buildStatusIndicator() {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador de monitoreo
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      controller.isMonitoring.value ? Colors.green : Colors.red,
                ),
                child: controller.isMonitoring.value
                    ? const Icon(Icons.check, size: 8, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                controller.isMonitoring.value
                    ? 'En monitoreo'
                    : 'Monitoreo detenido',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== INFORMACIÓN DEL NIÑO ====================

  Widget _buildNinoInfo() {
    return Positioned(
      top: 16,
      right: 16,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          constraints: const BoxConstraints(maxWidth: 180),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isNinoInsideArea.value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.isNinoInsideArea.value ? '✅ DENTRO' : '⚠️ FUERA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: controller.isNinoInsideArea.value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Ubicación
              if (controller.ninoLocation.value != null)
                Text(
                  'Lat: ${controller.ninoLocation.value!.latitude.toStringAsFixed(4)}\n'
                  'Lng: ${controller.ninoLocation.value!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),

              // Historial
              const SizedBox(height: 8),
              Text(
                'Puntos: ${controller.locationHistory.length}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== CONTROLES DE MONITOREO ====================

  Widget _buildMonitoringControls() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Obx(
        () => Row(
          children: [
            // Botón start/stop
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.isMonitoring.value
                    ? () => controller.stopMonitoring()
                    : () => controller.startMonitoring(
                          ninoId: ninoId,
                          areaId: areaId,
                        ),
                icon: Icon(
                  controller.isMonitoring.value
                      ? Icons.pause_circle
                      : Icons.play_circle,
                ),
                label: Text(
                  controller.isMonitoring.value ? 'Detener' : 'Iniciar',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isMonitoring.value
                      ? Colors.orange
                      : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Botón información
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                color: AppTheme.primaryColor,
                onPressed: () => _showDetailDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DIÁLOGOS ====================

  void _showDetailDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Detalles del Monitoreo'),
        content: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Niño
                if (controller.selectedNino.value != null) ...[
                  Text(
                    '👤 Niño: ${controller.selectedNino.value!.nombre}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],

                // Área
                if (controller.selectedArea.value != null) ...[
                  Text(
                    '📍 Área: ${controller.selectedArea.value!.nombre}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],

                // Estado
                Text(
                  'Estado: ${controller.isNinoInsideArea.value ? "✅ Dentro" : "⚠️ Fuera"}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: controller.isNinoInsideArea.value
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),

                // Ubicación actual
                if (controller.ninoLocation.value != null) ...[
                  const Text(
                    'Ubicación Actual:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lat: ${controller.ninoLocation.value!.latitude.toStringAsFixed(6)}',
                  ),
                  Text(
                    'Lng: ${controller.ninoLocation.value!.longitude.toStringAsFixed(6)}',
                  ),
                  const SizedBox(height: 8),
                ],

                // Historial
                Text(
                  'Historial: ${controller.locationHistory.length} puntos',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (controller.locationHistory.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Primer punto: ${controller.locationHistory.first.dateTime}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Último punto: ${controller.locationHistory.last.dateTime}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
