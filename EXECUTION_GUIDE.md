# Guía de Ejecución - SIGKids

## Precondiciones

### Software Requerido
1. **Flutter SDK** (versión 3.2.0 o superior)
   - Descarga desde: https://flutter.dev/docs/get-started/install

2. **Dart SDK** (incluido con Flutter)

3. **Android Studio** o **VS Code**
   - Con extensiones de Flutter

4. **Emulador Android** o **Dispositivo Físico**

### Configuración Previa

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/Jorgito-cc/smart_sig.git
   cd smart_sig
   ```

2. **Cambiar baseUrl si es necesario**
   - Archivo: `lib/config/app_constants.dart`
   - Línea: `static const String baseUrl = 'http://192.168.0.7:8000';`
   - Modificar según tu IP del backend

---

## Pasos para Ejecutar

### Opción 1: Ejecución Normal (Debug)

```powershell
# 1. Navegar al directorio del proyecto
cd d:\sig\smart_sig

# 2. Limpiar proyecto
flutter clean

# 3. Obtener dependencias
flutter pub get

# 4. Ejecutar en emulador/dispositivo
flutter run
```

**Tiempo estimado**: 3-5 minutos (primera ejecución)

### Opción 2: Ejecución en Release (Optimizada)

```powershell
cd d:\sig\smart_sig
flutter clean
flutter pub get
flutter run --release
```

**Ventajas**: 
- Performance mejorado
- Sin logs de debug
- Menor consumo de RAM

### Opción 3: Ejecución con Argumento de Configuración

```powershell
# Ejecutar con logging mejorado
flutter run --verbose

# Ejecutar con profiling
flutter run --profile
```

---

## Verificación de Instalación

Antes de ejecutar, verifica que todo está configurado:

```powershell
# Ver versión de Flutter
flutter --version

# Ver SDK path
flutter sdk-path

# Verificar dispositivos conectados
flutter devices

# Analizar proyecto
flutter analyze
```

---

## Flujo de la Aplicación

### 1. Splash Screen (800ms)
- Se muestra logo animado
- No hace verificaciones de token
- Redirige automáticamente a Login

### 2. Login/Register
**Opciones**:
- **Login**: Email + Contraseña
- **Registro**: Datos personales + Email + Contraseña

**Validaciones**:
- Email válido
- Contraseña mínimo 6 caracteres
- Campos obligatorios completados

### 3. Home Pages
Depende del tipo de usuario:
- **Tutor**: HomeTutorPage con lista de hijos
- **Hijo**: HomeHijoPage con tutores y areas

---

## Configuración del Backend

### BaseUrl
Archivo: `lib/config/app_constants.dart`

```dart
static const String baseUrl = 'http://192.168.0.7:8000'; // Cambiar aquí
```

### Obtener IP Local Windows
```powershell
ipconfig
```
Buscar en "Adaptador Ethernet" o "Adaptador de red inalámbrica":
- Dirección IPv4: XXX.XXX.X.X

---

## Solución de Problemas

### Error: "No devices found"
```powershell
flutter devices
# Si no aparecen dispositivos:
# - Conectar dispositivo USB
# - Habilitar "USB Debugging" en dispositivo
# - Autorizar conexión en dispositivo
```

### Error: "pubspec.yaml" not found
```powershell
# Asegúrate de estar en el directorio correcto
cd d:\sig\smart_sig
ls  # Verificar que ves pubspec.yaml
```

### Error: Dependencies not found
```powershell
flutter clean
flutter pub get
```

### Error: "Dart SDK not found"
```powershell
# Reinstalar Flutter
flutter upgrade
```

### Backend no responde
- Verificar IP en `app_constants.dart`
- Verificar que backend está corriendo
- Verificar conectividad de red

---

## Desarrollo en Vivo

### Hot Reload (Recargar sin reiniciar)
Mientras la app está ejecutándose:
- Presionar `r` en la terminal
- O presionar botón de "Hot Reload" en VS Code

**Nota**: No reinicia la aplicación, solo recarga el código

### Hot Restart (Reiniciar app)
- Presionar `R` en la terminal
- Reinicia la app completamente

### Detener la aplicación
- Presionar `q` en la terminal

---

## Testing (Futuro)

Cuando tengas tests:
```powershell
# Ejecutar tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage
```

---

## Construir APK (Android)

```powershell
# Debug APK
flutter build apk --debug

# Release APK (requiere clave privada)
flutter build apk --release

# APK se genera en:
# build\app\outputs\apk\
```

---

## Logs y Debugging

### Ver logs en vivo
```powershell
flutter logs
```

### Usar Flutter DevTools
```powershell
# Abrir DevTools
flutter pub global run devtools

# O automáticamente con:
flutter run --devtools
```

**URL**: http://localhost:9100

---

## Performance Profiling

```powershell
# Ejecutar con profiling
flutter run --profile

# Esto permite:
# - Ver timeline de renders
# - Detectar jank (frame drops)
# - Analizar memoria
```

---

## Checklist Antes de Ejecutar

- [ ] Flutter instalado y actualizado
- [ ] Dispositivo/Emulador conectado
- [ ] Backend configurado y ejecutándose
- [ ] BaseUrl correcto en app_constants.dart
- [ ] Dependencias instaladas (`flutter pub get`)
- [ ] Código sin errores de compilación

---

## Comandos Útiles

```powershell
# Obtener versión
flutter --version

# Actualizar Flutter
flutter upgrade

# Limpiar todo
flutter clean

# Obtener dependencias
flutter pub get

# Analizar código
flutter analyze

# Ver dispositivos
flutter devices

# Logs en tiempo real
flutter logs

# Ejecución verbose
flutter run -v

# Ejecución sin despliegue (solo compilación)
flutter build apk
```

---

## Estructura de Directorios Importantes

```
lib/
├── main.dart                 # Punto de entrada
├── api/                      # APIs HTTP
├── config/                   # Configuración global
├── models/                   # Data models
├── presentation/
│   ├── pages/              # Pantallas
│   ├── controllers/        # Lógica de negocio
│   ├── widgets/            # Componentes reutilizables
│   └── bindings/           # Inyección de dependencias
└── routes/                 # Navegación

pubspec.yaml                 # Dependencias del proyecto
analysis_options.yaml        # Configuración de análisis
```

---

## Recursos Adicionales

- **Flutter Docs**: https://flutter.dev/docs
- **Dart Docs**: https://dart.dev/guides
- **GetX Documentation**: https://github.com/jonataslaw/getx
- **Dio HTTP Client**: https://pub.dev/packages/dio
- **Google Maps Flutter**: https://pub.dev/packages/google_maps_flutter

---

**Documento creado**: 7 de Diciembre de 2025
**Desarrollador**: Jorge Choque Calle
**Estado**: LISTO PARA EJECUTAR