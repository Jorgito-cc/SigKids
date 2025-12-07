import 'package:json_annotation/json_annotation.dart';

part 'usuario_model.g.dart';

/// Modelo de Usuario (User)
@JsonSerializable()
class UsuarioModel {
  final int id;
  final String email;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'is_superuser')
  final bool isSuperuser;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  UsuarioModel({
    required this.id,
    required this.email,
    this.isActive = true,
    this.isSuperuser = false,
    this.isVerified = false,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModelFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioModelToJson(this);

  UsuarioModel copyWith({
    int? id,
    String? email,
    bool? isActive,
    bool? isSuperuser,
    bool? isVerified,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

/// Modelo para registro de usuario
@JsonSerializable()
class UsuarioCreateModel {
  final String email;
  final String password;

  UsuarioCreateModel({
    required this.email,
    required this.password,
  });

  factory UsuarioCreateModel.fromJson(Map<String, dynamic> json) =>
      _$UsuarioCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioCreateModelToJson(this);
}

/// Modelo para login
@JsonSerializable()
class LoginModel {
  final String username; // FastAPI-Users usa 'username' para el email
  final String password;

  LoginModel({
    required this.username,
    required this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

/// Modelo de respuesta de login
@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
