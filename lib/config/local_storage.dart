import 'package:get_storage/get_storage.dart';
import 'app_constants.dart';

/// Servicio de almacenamiento local usando GetStorage
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final GetStorage _storage = GetStorage();

  // Token de autenticación
  Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.storageKeyToken, token);
  }

  String? getToken() {
    return _storage.read<String>(AppConstants.storageKeyToken);
  }

  Future<void> removeToken() async {
    await _storage.remove(AppConstants.storageKeyToken);
  }

  bool hasToken() {
    return _storage.hasData(AppConstants.storageKeyToken);
  }

  // Datos de usuario
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(AppConstants.storageKeyUser, userData);
  }

  Map<String, dynamic>? getUser() {
    return _storage.read<Map<String, dynamic>>(AppConstants.storageKeyUser);
  }

  Future<void> removeUser() async {
    await _storage.remove(AppConstants.storageKeyUser);
  }

  // Datos de tutor
  Future<void> saveTutor(Map<String, dynamic> tutorData) async {
    await _storage.write(AppConstants.storageKeyTutor, tutorData);
  }

  Map<String, dynamic>? getTutor() {
    return _storage.read<Map<String, dynamic>>(AppConstants.storageKeyTutor);
  }

  Future<void> removeTutor() async {
    await _storage.remove(AppConstants.storageKeyTutor);
  }

  // Tema
  Future<void> saveThemeMode(String mode) async {
    await _storage.write(AppConstants.storageKeyTheme, mode);
  }

  String getThemeMode() {
    return _storage.read<String>(AppConstants.storageKeyTheme) ?? 'dark';
  }

  // Primera vez
  Future<void> setFirstTime(bool isFirst) async {
    await _storage.write(AppConstants.storageKeyFirstTime, isFirst);
  }

  bool isFirstTime() {
    return _storage.read<bool>(AppConstants.storageKeyFirstTime) ?? true;
  }

  // Limpiar todo
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Limpiar sesión
  Future<void> clearSession() async {
    await removeToken();
    await removeUser();
    await removeTutor();
  }
}
