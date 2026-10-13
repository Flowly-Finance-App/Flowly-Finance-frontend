import '../entities/auth_session_entity.dart';
import '../entities/user_entity.dart';


abstract class AuthRepository {
  Future<void> sendEmailOtp({
    required String email,
    String purpose = 'registration',
  });

  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
    String purpose = 'registration',
  });

  Future<AuthSessionEntity> login({
    required String email,
    required String mpin,
  });

  Future<AuthSessionEntity> googleLogin({
    required String idToken,
    String? email,
    String? name,
    String? googleId,
    String? phone,
  });

  Future<UserEntity> getMe();
}