# Proyecto de Sistema de Información Geográfica

## Desarrollador
Jorge Choque Calle

## Descripción del Proyecto
Este proyecto es un Sistema de Información Geográfica (SIG) desarrollado como una aplicación móvil utilizando Flutter. La aplicación permite gestionar y visualizar información geográfica, integrando diversas funcionalidades como autenticación, gestión de usuarios, mapas interactivos, y más.

## Arquitectura del Proyecto
La aplicación sigue una arquitectura basada en el patrón **MVC (Modelo-Vista-Controlador)**, con una estructura modular que facilita la escalabilidad y el mantenimiento. A continuación, se describen los principales componentes:

- **Modelos (`lib/models`)**: Contienen las clases que representan los datos y su lógica de negocio. Ejemplo: `area_model.dart`, `nino_model.dart`.
- **Controladores (`lib/presentation/controllers`)**: Gestionan la lógica de la aplicación y actúan como intermediarios entre los modelos y las vistas. Ejemplo: `area_controller.dart`, `login_controller.dart`.
- **Vistas (`lib/presentation/pages`)**: Contienen las interfaces de usuario divididas en diferentes módulos como `home`, `login`, `mapa`, etc.
- **Rutas (`lib/routes`)**: Define las rutas de navegación de la aplicación. Ejemplo: `app_routes.dart`.
- **APIs (`lib/api`)**: Manejan la comunicación con servicios externos o backend. Ejemplo: `auth_api.dart`, `nino_api.dart`.
- **Configuraciones (`lib/config`)**: Contienen constantes, temas y utilidades generales. Ejemplo: `app_constants.dart`, `app_theme.dart`.

## Requisitos Previos
Antes de ejecutar la aplicación, asegúrate de tener instalados los siguientes requisitos:

1. **Flutter**: Instala Flutter siguiendo las instrucciones oficiales en [flutter.dev](https://flutter.dev/docs/get-started/install).
2. **Dart SDK**: Incluido con Flutter.
3. **Android Studio o Visual Studio Code**: Para emular dispositivos o editar el código.
4. **Dispositivo o Emulador**: Configura un dispositivo físico o un emulador para probar la aplicación.

## Cómo Ejecutar el Proyecto
Sigue estos pasos para ejecutar la aplicación:

1. Clona el repositorio del proyecto:
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd smart_sig
   ```

2. Instala las dependencias del proyecto:
   ```bash
   flutter pub get
   ```

3. Conecta un dispositivo físico o inicia un emulador.

4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Estructura del Proyecto
La estructura principal del proyecto es la siguiente:

```
lib/
├── api/                # Manejo de APIs y servicios externos
├── config/             # Configuraciones generales y utilidades
├── models/             # Modelos de datos
├── presentation/       # Controladores, vistas y widgets
│   ├── bindings/       # Enlaces de dependencias
│   ├── controllers/    # Lógica de negocio
│   ├── pages/          # Interfaces de usuario
│   └── widgets/        # Componentes reutilizables
├── routes/             # Definición de rutas de navegación
└── main.dart           # Punto de entrada de la aplicación
```

## Notas Adicionales
- Asegúrate de configurar correctamente los archivos `android/local.properties` e `ios/Runner/Info.plist` si necesitas integrar servicios como Google Maps o notificaciones push.
- Para generar modelos o controladores adicionales, sigue la estructura modular existente.

---

Para cualquier consulta o soporte, contacta al desarrollador: **Jorge Choque Calle**.

SIGKids - Guía de Inicio Rápido
🎉 ¡Proyecto Creado Exitosamente!
Se ha generado la estructura completa de la aplicación SIGKids - Monitoreo Infantil con Flutter + GetX.

📂 Estructura del Proyecto
smart_sig/
├── lib/
│   ├── api/                          ✅ Servicios HTTP (Dio)
│   │   ├── api_client.dart           ✅ Cliente configurado
│   │   ├── auth_api.dart             ✅ Autenticación
│   │   ├── tutor_api.dart            ✅ Tutores
│   │   ├── nino_api.dart             ✅ Niños
│   │   ├── area_api.dart             ✅ Áreas (preparatorio)
│   │   └── ubicacion_api.dart        ✅ Ubicaciones (preparatorio)
│   │
│   ├── models/                       ✅ Modelos con JSON serialization
│   │   ├── usuario_model.dart        ✅ Usuario, Login
│   │   ├── tutor_model.dart          ✅ Tutor
│   │   ├── nino_model.dart           ✅ Niño
│   │   ├── area_model.dart           ✅ Área con polígonos
│   │   └── ubicacion_model.dart      ✅ Ubicación
│   │
│   ├── config/                       ✅ Configuración
│   │   ├── app_constants.dart        ✅ Constantes
│   │   ├── app_theme.dart            ✅ Tema mágico infantil
│   │   ├── local_storage.dart        ✅ GetStorage wrapper
│   │   └── geo_utils.dart            ✅ Algoritmos SIG
│   │
│   ├── routes/                       ✅ Navegación
│   │   ├── app_routes.dart           ✅ Rutas
│   │   └── app_pages.dart            ✅ Páginas GetX
│   │
│   ├── presentation/                 ⚠️ Parcialmente implementado
│   │   ├── controllers/
│   │   │   ├── splash_controller.dart    ✅ Splash
│   │   │   ├── login_controller.dart     ✅ Login/Register
│   │   │   └── home_controller.dart      ⚠️ Placeholder
│   │   │
│   │   ├── bindings/                 ✅ Todos creados
│   │   │   ├── splash_binding.dart
│   │   │   ├── login_binding.dart
│   │   │   ├── home_binding.dart
│   │   │   ├── nino_binding.dart
│   │   │   ├── area_binding.dart
│   │   │   └── mapa_binding.dart
│   │   │
│   │   └── pages/                    ⚠️ Placeholders
│   │       ├── splash/splash_page.dart   ✅ Implementada
│   │       └── login/login_page.dart     ⚠️ Placeholder
│   │
│   └── main.dart                     ✅ Configurado
│
├── assets/                           ✅ Carpetas creadas
│   ├── images/
│   ├── lottie/
│   └── icons/
│
└── pubspec.yaml                      ✅ Dependencias configuradas
🚀 Cómo Ejecutar el Proyecto
1. Instalar Dependencias
cd d:\sig\smart_sig
flutter pub get
2. Generar Código JSON Serialization
Los modelos usan json_annotation y necesitan generar archivos .g.dart:

flutter pub run build_runner build --delete-conflicting-outputs
Esto generará:

usuario_model.g.dart
tutor_model.g.dart
nino_model.g.dart
area_model.g.dart
ubicacion_model.g.dart
3. Configurar Backend
Asegúrate de que tu backend FastAPI esté corriendo:

cd d:\sig\GeoControlParental-API
uvicorn app.main:app --reload
Por defecto corre en http://localhost:8000

4. Actualizar URL del Backend (si es necesario)
Si tu backend está en otra IP o puerto, edita:

app_constants.dart

static const String baseUrl = 'http://TU_IP:8000';
5. Ejecutar la App
flutter run
O desde VS Code/Android Studio: presiona F5

⚠️ Tareas Pendientes
Backend (CRÍTICO)
Tu backend actual solo tiene:

✅ Usuarios (auth)
✅ Tutores
✅ Hijos (niños)
Necesitas implementar:

1. Modelo de Área
# app/models/area_model.py
from sqlalchemy import Column, Integer, String, JSON, DateTime, ForeignKey
from datetime import datetime
from ..config.db import Base
class Area(Base):
    __tablename__ = "area"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    nombre = Column(String, nullable=False)
    vertices = Column(JSON, nullable=False)  # [{"lat": -32.9460, "lng": -60.6391}, ...]
    estado = Column(String, default="ACTIVO")  # ACTIVO/INACTIVO
    id_tutor_creador = Column(Integer, ForeignKey("tutor.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.now)
2. Modelo de Ubicación
# app/models/ubicacion_model.py
from sqlalchemy import Column, Integer, Float, Boolean, DateTime, ForeignKey
from datetime import datetime
from ..config.db import Base
class Ubicacion(Base):
    __tablename__ = "ubicacion"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    latitud = Column(Float, nullable=False)
    longitud = Column(Float, nullable=False)
    esta_dentro = Column(Boolean, nullable=False)
    fecha_hora = Column(DateTime, default=datetime.now)
    id_area = Column(Integer, ForeignKey("area.id"), nullable=False)
    id_nino = Column(Integer, ForeignKey("hijo.id"), nullable=False)
3. Tabla de Asociación Área-Niño
# app/models/area_nino_model.py
from sqlalchemy import Table, Column, Integer, ForeignKey, DateTime
from datetime import datetime
from ..config.db import Base
area_nino_association = Table(
    "area_nino_association",
    Base.metadata,
    Column("area_id", ForeignKey("area.id"), primary_key=True),
    Column("nino_id", ForeignKey("hijo.id"), primary_key=True),
    Column("fecha_asignacion", DateTime, default=datetime.now),
)
4. Schemas
# app/schemas/area_schemas.py
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
class AreaCreate(BaseModel):
    nombre: str
    vertices: List[dict]  # [{"lat": float, "lng": float}]
    estado: str = "ACTIVO"
    id_tutor_creador: int
class AreaResponse(BaseModel):
    id: int
    nombre: str
    vertices: List[dict]
    estado: str
    id_tutor_creador: int
    created_at: datetime
class AreaUpdate(BaseModel):
    nombre: Optional[str] = None
    vertices: Optional[List[dict]] = None
    estado: Optional[str] = None
# app/schemas/ubicacion_schemas.py
from pydantic import BaseModel
from datetime import datetime
class UbicacionCreate(BaseModel):
    latitud: float
    longitud: float
    esta_dentro: bool
    id_area: int
    id_nino: int
class UbicacionResponse(BaseModel):
    id: int
    latitud: float
    longitud: float
    esta_dentro: bool
    fecha_hora: datetime
    id_area: int
    id_nino: int
5. Controllers y Routes
Sigue el mismo patrón que tienes en tutor_controller.py y 
tutor_route.py

Flutter (Pantallas UI)
Pantallas Prioritarias
LoginPage - Pantalla de login/registro con diseño mágico
HomePage - Dashboard con cards animadas
NinoListPage - Lista de niños con avatares
NinoFormPage - Formulario para crear/editar niño
AreaListPage - Lista de áreas con estado
AreaFormPage - Mapa para dibujar polígono
AsignacionPage - Asignar niños a áreas
MapaMonitoreoPage - Mapa en tiempo real
HistorialPage - Historial de ubicaciones
Widgets Reutilizables Necesarios
// lib/presentation/widgets/custom_button.dart
// lib/presentation/widgets/custom_input.dart
// lib/presentation/widgets/child_avatar.dart
// lib/presentation/widgets/loading_overlay.dart
// lib/presentation/widgets/empty_state.dart
// lib/presentation/widgets/error_state.dart
🎨 Mockups de Referencia
Login Screen
Review
Login Screen

🔧 Algoritmo SIG Implementado
El algoritmo Ray Casting para determinar si un punto está dentro de un polígono ya está implementado en:

geo_utils.dart

static bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  // Implementación completa del algoritmo Ray Casting
  // ...
}
Uso:

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/geo_utils.dart';
// Definir área
List<LatLng> areaVertices = [
  LatLng(-32.9460, -60.6391),
  LatLng(-32.9470, -60.6400),
  LatLng(-32.9480, -60.6380),
];
// Posición del niño
LatLng posicionNino = LatLng(-32.9465, -60.6395);
// Verificar
bool estaDentro = GeoUtils.isPointInPolygon(posicionNino, areaVertices);
if (estaDentro) {
  print('✅ El niño está dentro del área segura');
} else {
  print('⚠️ ALERTA: El niño salió del área segura');
  // Disparar notificación
}
📱 Casos de Uso - Estado de Implementación
CU	Descripción	Backend	Flutter	Estado
CU01	Gestionar área de monitoreo	❌	✅	Falta backend
CU02	Gestionar niño	✅	⚠️	Falta UI
CU03	Asignar área a niño	❌	✅	Falta backend
CU04	Registrar ubicación	❌	✅	Falta backend
CU05	Validar área con SIG	❌	✅	Algoritmo listo
CU06	Visualizar en mapa	❌	⚠️	Falta UI
CU07	Monitoreo en tiempo real	❌	⚠️	Falta implementar
CU08	Notificación de alerta	❌	⚠️	Falta implementar
CU09	Historial de ubicaciones	❌	⚠️	Falta backend y UI
🔔 Implementar Notificaciones
1. Crear Servicio de Notificaciones
// lib/config/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(initSettings);
  }
  
  Future<void> showAlertaFueraDeArea(String ninoNombre) async {
    const androidDetails = AndroidNotificationDetails(
      'sigkids_alerts',
      'Alertas de Seguridad',
      channelDescription: 'Notificaciones cuando un niño sale del área segura',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFF5252),
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      0,
      '⚠️ Alerta de Seguridad',
      '$ninoNombre ha salido del área segura',
      details,
    );
  }
}
2. Inicializar en main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  ApiClient().initialize();
  
  // Inicializar notificaciones
  await NotificationService().initialize();
  
  runApp(const MyApp());
}
🗺️ Implementar Monitoreo en Tiempo Real
Controller de Monitoreo
// lib/presentation/controllers/monitoreo_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../api/ubicacion_api.dart';
import '../../api/area_api.dart';
import '../../models/ubicacion_model.dart';
import '../../models/area_model.dart';
import '../../config/geo_utils.dart';
import '../../config/notification_service.dart';
import '../../config/app_constants.dart';
class MonitoreoController extends GetxController {
  final UbicacionApi _ubicacionApi = UbicacionApi();
  final AreaApi _areaApi = AreaApi();
  final NotificationService _notificationService = NotificationService();
  
  Timer? _timer;
  final intervaloActual = AppConstants.monitoreoIntervalNormal.obs;
  final isMonitoring = false.obs;
  final ultimaUbicacion = Rxn<UbicacionModel>();
  final areaActual = Rxn<AreaModel>();
  
  int ninoId = 0;
  int areaId = 0;
  String ninoNombre = '';
  
  void iniciarMonitoreo({
    required int ninoId,
    required int areaId,
    required String ninoNombre,
    bool modoIntenso = false,
  }) {
    this.ninoId = ninoId;
    this.areaId = areaId;
    this.ninoNombre = ninoNombre;
    
    intervaloActual.value = modoIntenso 
        ? AppConstants.monitoreoIntervalIntenso 
        : AppConstants.monitoreoIntervalNormal;
    
    isMonitoring.value = true;
    
    // Cargar área
    _cargarArea();
    
    // Iniciar timer
    _timer = Timer.periodic(
      Duration(seconds: intervaloActual.value),
      (_) => _verificarUbicacion(),
    );
    
    // Primera verificación inmediata
    _verificarUbicacion();
  }
  
  void detenerMonitoreo() {
    _timer?.cancel();
    isMonitoring.value = false;
  }
  
  void cambiarIntervalo(bool intenso) {
    intervaloActual.value = intenso 
        ? AppConstants.monitoreoIntervalIntenso 
        : AppConstants.monitoreoIntervalNormal;
    
    // Reiniciar timer con nuevo intervalo
    if (isMonitoring.value) {
      _timer?.cancel();
      _timer = Timer.periodic(
        Duration(seconds: intervaloActual.value),
        (_) => _verificarUbicacion(),
      );
    }
  }
  
  Future<void> _cargarArea() async {
    try {
      final area = await _areaApi.getAreaById(areaId);
      areaActual.value = area;
    } catch (e) {
      print('Error cargando área: $e');
    }
  }
  
  Future<void> _verificarUbicacion() async {
    try {
      // Obtener ubicación GPS
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (areaActual.value == null) return;
      
      // Verificar si está dentro del área usando algoritmo SIG
      final puntoNino = LatLng(position.latitude, position.longitude);
      final estaDentro = GeoUtils.isPointInPolygon(
        puntoNino,
        areaActual.value!.verticesLatLng,
      );
      
      // Crear ubicación
      final ubicacion = UbicacionCreateModel(
        latitud: position.latitude,
        longitud: position.longitude,
        estaDentro: estaDentro,
        idArea: areaId,
        idNino: ninoId,
      );
      
      // Enviar a API
      final ubicacionGuardada = await _ubicacionApi.createUbicacion(ubicacion);
      ultimaUbicacion.value = ubicacionGuardada;
      
      // Si salió del área, disparar notificación
      if (!estaDentro) {
        await _notificationService.showAlertaFueraDeArea(ninoNombre);
      }
      
    } catch (e) {
      print('Error verificando ubicación: $e');
    }
  }
  
  @override
  void onClose() {
    detenerMonitoreo();
    super.onClose();
  }
}
📋 Checklist de Próximos Pasos
Inmediato (Hoy)
 Ejecutar flutter pub get
 Ejecutar flutter pub run build_runner build --delete-conflicting-outputs
 Verificar que compila sin errores
 Probar pantalla de Splash
Backend (Esta Semana)
 Crear modelo 
Area
 en FastAPI
 Crear modelo 
Ubicacion
 en FastAPI
 Crear tabla de asociación area_nino
 Implementar CRUD de áreas
 Implementar CRUD de ubicaciones
 Probar endpoints con Postman
Flutter UI (Esta Semana)
 Implementar 
LoginPage
 con diseño mágico
 Implementar 
HomePage
 con dashboard
 Implementar 
NinoListPage
 Implementar 
NinoFormPage
 Crear widgets reutilizables (CustomButton, CustomInput)
Funcionalidades Avanzadas (Próxima Semana)
 Implementar 
AreaFormPage
 con Google Maps
 Implementar dibujo de polígonos en mapa
 Implementar 
MapaMonitoreoPage
 Implementar monitoreo en tiempo real
 Implementar notificaciones
 Implementar 
HistorialPage
🐛 Solución de Problemas
Error: "No se puede generar .g.dart"
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
Error: "Google Maps no se muestra"
Verifica que la API Key esté en AndroidManifest.xml
Habilita las APIs en Google Cloud Console:
Maps SDK for Android
Maps SDK for iOS
Error: "No se puede conectar al backend"
Verifica que el backend esté corriendo
Verifica la URL en 
app_constants.dart
Si usas emulador Android, usa 10.0.2.2 en lugar de localhost
static const String baseUrl = 'http://10.0.2.2:8000';
📚 Recursos
Documentación Implementada
Implementation Plan
 - Plan completo de implementación
Archivos Clave
main.dart
 - Punto de entrada
app_theme.dart
 - Tema de la app
geo_utils.dart
 - Algoritmos SIG
api_client.dart
 - Cliente HTTP
login_controller.dart
 - Lógica de auth
Enlaces Útiles
GetX Documentation
Google Maps Flutter
Flutter Local Notifications
🎯 Objetivo Final
Una aplicación móvil completa que permita a tutores:

✅ Registrarse y autenticarse
✅ Gestionar niños a su cargo
✅ Crear áreas de seguridad en el mapa
✅ Asignar niños a áreas
✅ Monitorear ubicación en tiempo real
✅ Recibir alertas cuando salen del área
✅ Ver historial de movimientos

¡El proyecto está listo para continuar! 🚀

Comienza ejecutando:

cd d:\sig\smart_sig
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run