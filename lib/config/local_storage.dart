import 'package:get_storage/get_storage.dart';
import 'app_constants.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final box = GetStorage();

  // --------------------------
  // TOKEN
  // --------------------------
  Future<void> saveToken(String token) async =>
      box.write(AppConstants.storageKeyToken, token);

  String? getToken() => box.read(AppConstants.storageKeyToken);

  // --------------------------
  // ROL (TUTOR O HIJO)
  // --------------------------
  Future<void> saveUserRole(String role) async =>
      box.write(AppConstants.storageKeyUserRole, role);

  String? getUserRole() => box.read(AppConstants.storageKeyUserRole);

  bool isTutor() => getUserRole() == 'tutor';
  bool isHijo() => getUserRole() == 'hijo';

  // --------------------------
  // TUTOR
  // --------------------------
  Future<void> saveTutor(Map<String, dynamic> data) async =>
      box.write(AppConstants.storageKeyTutor, data);

  Map<String, dynamic>? getTutor() => box.read(AppConstants.storageKeyTutor);

  // --------------------------
  // HIJO
  // --------------------------
  Future<void> saveHijo(Map<String, dynamic> data) async =>
      box.write('hijo_data', data);

  Map<String, dynamic>? getHijo() => box.read('hijo_data');

  // --------------------------
  // USER ID
  // --------------------------
  Future<void> saveUserId(int id) async =>
      box.write(AppConstants.storageKeyUserId, id);

  int? getUserId() => box.read(AppConstants.storageKeyUserId);

  // --------------------------
  // LIMPIAR SESIÓN
  // --------------------------
  Future<void> clearSession() async => box.erase();
}
