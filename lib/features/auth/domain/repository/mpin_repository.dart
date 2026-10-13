import '../entities/auth_session_entity.dart';

abstract class MpinRepository {
  Future<void> sendMpinResetOtp(String email);

  Future<void> resetMpin({
    required String email,
    required String otp,
    required String newMpin,
  });

  Future<AuthSessionEntity> loginWithMpin({
    required String email,
    required String mpin,
  });
}