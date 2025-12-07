/// Constantes globales de la aplicación SIGKids
class AppConstants {
  // API Configuration
  static const String baseUrl =
      'http://192.168.0.7:8000'; // Cambiar por tu IP o dominio
  static const String apiVersion = 'v1';

  // Endpoints
  static const String authEndpoint = '/auth';
  static const String tutorEndpoint = '/tutor';
  static const String hijoEndpoint = '/hijo';
  static const String areaEndpoint = '/area';
  static const String ubicacionEndpoint = '/ubicacion';

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyTutor = 'tutor_data';
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyFirstTime = 'is_first_time';

  // Google Maps
  static const String googleMapsApiKey =
      'AIzaSyArEG6lLi25JaGEeIbdH3wGdSF5smXYYyY';

  // Monitoreo
  static const int monitoreoIntervalNormal = 20; // segundos
  static const int monitoreoIntervalIntenso = 5; // segundos

  // Timeouts
  static const int connectionTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms

  // Validaciones
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Animaciones
  static const int splashDuration = 3; // segundos
  static const int animationDuration = 300; // ms

  // Paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}