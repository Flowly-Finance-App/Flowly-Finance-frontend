import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepositoryImpl(this._remote);

  @override
  Future<void> sendEmailOtp({
    required String email,
    String purpose = 'registration',
  }) {
    return _remote.sendEmailOtp(email: email, purpose: purpose);
  }

  @override
  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
    String purpose = 'registration',
  }) {
    return _remote.verifyEmailOtp(email: email, otp: otp, purpose: purpose);
  }

  @override
  Future<AuthSessionEntity> login({
    required String email,
    required String mpin,
  }) async {
    final json = await _remote.login(email: email, mpin: mpin);
    return AuthSessionEntity.fromJson(json);
  }

  @override
  Future<AuthSessionEntity> googleLogin({
    required String idToken,
    String? email,
    String? name,
    String? googleId,
    String? phone,
  }) async {
    final json = await _remote.googleLogin(
      idToken: idToken,
      email: email,
      name: name,
      googleId: googleId,
      phone: phone,
    );
    return AuthSessionEntity.fromJson(json);
  }

  @override
  Future<UserEntity> getMe() async {
    final json = await _remote.getMe();
    final userJson = json['user'];
    return UserEntity.fromJson(
      userJson is Map ? Map<String, dynamic>.from(userJson) : json,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});