import 'package:get_storage/get_storage.dart';
import 'app_constants.dart';

/// Servicio de almacenamiento local usando GetStorage
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final GetStorage _storage = GetStorage();

  // --------------------------
  // TOKEN
  // --------------------------
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

  // --------------------------
  // USUARIO
  // --------------------------
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(AppConstants.storageKeyUser, userData);
  }

  Map<String, dynamic>? getUser() {
    return _storage.read<Map<String, dynamic>>(AppConstants.storageKeyUser);
  }

  Future<void> removeUser() async {
    await _storage.remove(AppConstants.storageKeyUser);
  }

  // --------------------------
  // TUTOR
  // --------------------------
  Future<void> saveTutor(Map<String, dynamic> tutorData) async {
    await _storage.write(AppConstants.storageKeyTutor, tutorData);
  }

  Map<String, dynamic>? getTutor() {
    return _storage.read<Map<String, dynamic>>(AppConstants.storageKeyTutor);
  }

  Future<void> removeTutor() async {
    await _storage.remove(AppConstants.storageKeyTutor);
  }

  // --------------------------
  // HIJO
  // --------------------------
  Future<void> saveHijo(Map<String, dynamic> hijoData) async {
    await _storage.write('hijo_data', hijoData);
  }

  Map<String, dynamic>? getHijo() {
    return _storage.read<Map<String, dynamic>>('hijo_data');
  }

  Future<void> removeHijo() async {
    await _storage.remove('hijo_data');
  }

  // --------------------------
  // Tipo Usuario
  // --------------------------
  Future<void> saveTipoUsuario(String tipo) async {
    await _storage.write('tipo_usuario', tipo);
  }

  String? getTipoUsuario() {
    return _storage.read<String>('tipo_usuario');
  }

  Future<void> removeTipoUsuario() async {
    await _storage.remove('tipo_usuario');
  }

  // --------------------------
  // Tema
  // --------------------------
  Future<void> saveThemeMode(String mode) async {
    await _storage.write(AppConstants.storageKeyTheme, mode);
  }

  String getThemeMode() {
    return _storage.read<String>(AppConstants.storageKeyTheme) ?? 'dark';
  }

  // --------------------------
  // Primera vez
  // --------------------------
  Future<void> setFirstTime(bool isFirst) async {
    await _storage.write(AppConstants.storageKeyFirstTime, isFirst);
  }

  bool isFirstTime() {
    return _storage.read<bool>(AppConstants.storageKeyFirstTime) ?? true;
  }

  // --------------------------
  // Limpiar todo
  // --------------------------
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // --------------------------
  // Limpiar solo sesión
  // --------------------------
  Future<void> clearSession() async {
    await removeToken();
    await removeUser();
    await removeTutor();
    await removeHijo();
    await removeTipoUsuario();
  }
}
