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
