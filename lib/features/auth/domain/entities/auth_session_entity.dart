import 'user_entity.dart';

class AuthSessionEntity {
  final String token;
  final UserEntity? user;

  const AuthSessionEntity({
    required this.token,
    this.user,
  });

  factory AuthSessionEntity.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AuthSessionEntity(
      token: json['token']?.toString() ?? '',
      user: userJson is Map
          ? UserEntity.fromJson(Map<String, dynamic>.from(userJson))
          : null,
    );
  }
}