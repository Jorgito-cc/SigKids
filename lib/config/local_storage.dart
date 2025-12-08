import 'package:get_storage/get_storage.dart';
import 'app_constants.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final box = GetStorage();

  // ==========================
  // TOKEN
  // ==========================
  Future<void> saveToken(String token) async {
    await box.write(AppConstants.storageKeyToken, token);
    await box.save();
  }

  String? getToken() => box.read(AppConstants.storageKeyToken);

  // ==========================
  // ROL
  // ==========================
  Future<void> saveUserRole(String role) async {
    await box.write(AppConstants.storageKeyUserRole, role);
    await box.save();
  }

  String getUserRole() =>
      box.read(AppConstants.storageKeyUserRole) ?? "hijo";

  bool isTutor() => getUserRole() == 'tutor';
  bool isHijo() => getUserRole() == 'hijo';

  // ==========================
  // USER ID
  // ==========================
  Future<void> saveUserId(int id) async {
    await box.write(AppConstants.storageKeyUserId, id);
    await box.save();
  }

  int? getUserId() => box.read(AppConstants.storageKeyUserId);

  // ==========================
  // DATOS TUTOR
  // ==========================
  Future<void> saveTutor(Map<String, dynamic> data) async {
    await box.write(AppConstants.storageKeyTutor, data);
    await box.save();
  }

  Map<String, dynamic>? getTutor() =>
      box.read(AppConstants.storageKeyTutor);

  // ==========================
  // DATOS HIJO
  // ==========================
  Future<void> saveHijo(Map<String, dynamic> data) async {
    await box.write(AppConstants.storageKeyHijo, data);
    await box.save();
  }

  Map<String, dynamic>? getHijo() =>
      box.read(AppConstants.storageKeyHijo);

  // ==========================
  // VALIDAR SESIÓN
  // ==========================
  bool isLoggedIn() =>
      getToken() != null && getUserId() != null;

  // ==========================
  // LIMPIAR TODO
  // ==========================
  Future<void> clearSession() async {
    await box.erase();
    await box.save();
  }
}
