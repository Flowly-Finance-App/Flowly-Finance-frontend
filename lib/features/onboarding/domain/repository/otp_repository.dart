abstract class OtpRepository {
  Future<void> sendOtp({required String email, String purpose = 'registration'});
  Future<void> verifyOtp({
    required String email,
    required String otp,
    String purpose = 'registration',
  });
}