# 🗺️ FASE 6: MAPA + MONITOREO - GUÍA DE IMPLEMENTACIÓN

## 📋 Orden de Implementación Recomendado

### 1️⃣ **Google Maps Setup** (Preparación)
```bash
# Ya deberías tener en pubspec.yaml:
- google_maps_flutter
- location (para GPS)
- geolocator (alternativa)
```

**Qué hacer:**
- Verificar API key en `android/local.properties`
- Verificar API key en `ios/Runner/GoogleService-Info.plist`
- Probar que Google Maps funciona en MapaPage

### 2️⃣ **Crear AreaMapPage (Nuevo Componente)**
```
lib/presentation/pages/area/
├── area_map_page.dart (NUEVO)  ← Dibujar polígono
├── area_list_page.dart ✅
└── area_form_page.dart ✅
```

**Funcionalidades:**
- Ver mapa de Google Maps
- Dibujar polígono tocando en el mapa
- Guardar vértices del polígono
- Enviar al backend `/area/` con los vértices

**API Endpoint:**
```dart
POST /area/
{
  "nombre": "Mi Area Segura",
  "vertices": [
    {"lat": -32.9460, "lng": -60.6391},
    {"lat": -32.9465, "lng": -60.6385},
    {"lat": -32.9470, "lng": -60.6390}
  ],
  "id_tutor_creador": 1
}
```

### 3️⃣ **LocationService (Singleton)**
Crear archivo: `lib/services/location_service.dart`

```dart
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final Geolocator _geolocator = Geolocator();
  final location.Location _location = location.Location();

  // Obtener ubicación actual
  Future<LatLng> getCurrentLocation() async { ... }

  // Escuchar cambios de ubicación cada 20s
  Stream<LatLng> getLocationStream() async* { ... }

  // Verificar si está dentro del polígono
  bool isInsideArea(LatLng point, List<LatLng> areaVertices) { ... }
}
```

### 4️⃣ **MonitoreoService (Para enviar GPS)**
Crear archivo: `lib/services/monitoreo_service.dart`

```dart
class MonitoreoService {
  static final MonitoreoService _instance = MonitoreoService._internal();
  factory MonitoreoService() => _instance;
  MonitoreoService._internal();

  final UbicacionApi _ubicacionApi = UbicacionApi();
  final LocationService _locationService = LocationService();

  // Iniciar monitoreo (envía GPS cada 20s)
  void startMonitoreo(int hijoId, int areId) {
    _monitoreoTimer = Timer.periodic(
      Duration(seconds: AppConstants.monitoreoIntervalNormal),
      (_) async {
        final location = await _locationService.getCurrentLocation();
        await _ubicacionApi.createUbicacion(
          UbicacionCreateModel(
            latitud: location.latitude,
            longitud: location.longitude,
            idArea: areaId,
            idNino: hijoId,
          ),
        );
      },
    );
  }

  // Detener monitoreo
  void stopMonitoreo() {
    _monitoreoTimer?.cancel();
  }
}
```

### 5️⃣ **MapaMonitoreoPage (Nuevo Componente)**
```
lib/presentation/pages/mapa/
├── mapa_monitoreo_page.dart (RENOVAR)  ← Monitoreo en tiempo real
├── mapa_page.dart ✅
```

**Funcionalidades:**
- Mostrar área segura (polígono en el mapa)
- Mostrar hijo como marcador
- Color verde si está dentro, rojo si está fuera
- Actualizar cada 20 segundos
- Mostrar última actualización

**Código estructura:**
```dart
class MapaMonitoreoPage extends GetView<MapaController> {
  const MapaMonitoreoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: controller.onMapCreated,
            polygons: controller.areaPolygon.toSet(),
            markers: controller.hijoMarkers.toSet(),
          ),
          // 2. Información en card
          _buildStatusCard(),
        ],
      )),
    );
  }
}
```

### 6️⃣ **MapaController (Actualizar)**
```dart
class MapaController extends GetxController {
  final LocationService _locationService = LocationService();
  final MonitoreoService _monitoreoService = MonitoreoService();

  var areaPolygon = <Polygon>[].obs;
  var hijoMarkers = <Marker>[].obs;
  var isInsideArea = true.obs;
  var lastUpdate = DateTime.now().obs;

  late GoogleMapController mapController;

  @override
  void onInit() {
    super.onInit();
    _loadAreaYHijo();
    _startMonitoreo();
  }

  void _loadAreaYHijo() {
    // Obtener área y hijo de storage
    // Dibujar polígono del área
    // Actualizar marcador del hijo
  }

  void _startMonitoreo() {
    _monitoreoService.startMonitoreo(hijoId, areaId);
    // Escuchar cambios de ubicación
    _locationService.getLocationStream().listen((location) {
      _updateHijoMarker(location);
      _checkIfInsideArea(location);
      lastUpdate.value = DateTime.now();
    });
  }

  void _updateHijoMarker(LatLng location) {
    hijoMarkers.clear();
    hijoMarkers.add(
      Marker(
        markerId: MarkerId('hijo'),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isInsideArea.value
            ? BitmapDescriptor.hueGreen
            : BitmapDescriptor.hueRed,
        ),
      ),
    );
  }

  void _checkIfInsideArea(LatLng location) {
    isInsideArea.value = GeoUtils.isPointInPolygon(location, areaVertices);
    if (!isInsideArea.value) {
      _notifyOutsideArea();
    }
  }

  void _notifyOutsideArea() {
    Get.snackbar(
      '⚠️ Alerta',
      'Tu hijo está FUERA del área segura',
      duration: Duration(seconds: 10),
    );
  }

  @override
  void onClose() {
    mapController.dispose();
    _monitoreoService.stopMonitoreo();
    super.onClose();
  }
}
```

### 7️⃣ **Notificaciones (Opcional pero Recomendado)**
Usar `flutter_local_notifications` (ya en pubspec.yaml)

```dart
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  
  Future<void> showAlertOutsideArea() async {
    await _localNotifications.show(
      0,
      '⚠️ Alerta de Area',
      'Tu hijo está FUERA del área segura',
      NotificationDetails(...),
    );
  }
}
```

### 8️⃣ **Flujo de Usuario Final**

```
HomeTutor
  ↓
Ver lista de hijos
  ↓
Click "Monitorear"
  ↓
MapaMonitoreoPage
  ├─ Muestra área (polígono)
  ├─ Muestra hijo (marcador)
  ├─ Actualiza cada 20s
  ├─ Notifica si sale del área
  └─ Muestra última actualización

OR

AreaFormPage
  ↓
Click en el mapa para dibujar vértices
  ↓
Guardar área
  ↓
Asignar niños a esa área
```

## 📦 Dependencias Necesarias

Verificar en `pubspec.yaml`:
```yaml
dependencies:
  google_maps_flutter: ^2.2.0
  geolocator: ^10.0.0
  location: ^5.0.0
  flutter_local_notifications: ^17.0.0
  latlong2: ^0.9.0
  path_provider: ^2.0.0
```

## 🔌 Endpoints Backend Esperados

```
POST   /ubicacion/          → Crear registro de ubicación
GET    /ubicacion/          → Obtener ubicaciones (con filtro)
GET    /area/               → Listar áreas
GET    /area/{id}           → Obtener área específica
POST   /area/               → Crear área
PUT    /area/{id}           → Actualizar área
DELETE /area/{id}           → Eliminar área
GET    /nino/{id}/ubicacion → Obtener ubicación actual del niño
```

## 🧪 Testing Manual

1. **Crear área:**
   - Ir a Areas → Crear
   - Dibujar polígono en mapa
   - Guardar

2. **Monitorear niño:**
   - Ir a HomeTutor
   - Click en hijo
   - Ver en mapa
   - Verificar que se actualiza cada 20s

3. **Notificación:**
   - Cambiar ubicación (simular con emulador)
   - Salir del área
   - Verificar notificación

## 🎯 Checklist de Implementación

- [ ] LocationService creado y testado
- [ ] MonitoreoService creado
- [ ] AreaMapPage implementado
- [ ] MapaMonitoreoPage renovado
- [ ] MapaController actualizado
- [ ] Notificaciones configuradas
- [ ] Endpoints disponibles en backend
- [ ] Testing manual completado
- [ ] Performance optimizado (no lag en mapa)
- [ ] Batería optimizada (location sampling cada 20s)

---

**Comenzar cuando el backend esté listo con:**
- POST /ubicacion/
- GET /area/{id}
- Atributo `role` en usuario
