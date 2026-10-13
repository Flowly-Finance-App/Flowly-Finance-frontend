import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpRemoteDataSource {
  final Dio _dio;
  OtpRemoteDataSource(this._dio);

  Future<void> sendOtp({required String email, required String purpose}) async {
    await _dio.post('/auth/otp/send', data: {'email': email, 'purpose': purpose});
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  }) async {
    await _dio.post('/auth/otp/verify', data: {
      'email': email,
      'otp': otp,
      'purpose': purpose,
    });
  }
}

final otpRemoteDataSourceProvider = Provider<OtpRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return OtpRemoteDataSource(dio);
});