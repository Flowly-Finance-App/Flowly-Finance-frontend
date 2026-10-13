import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingRemoteDataSource {
  final Dio _dio;

  OnboardingRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final response = await _dio.post('/auth/user/register', data: payload);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  Future<void> submitKyc(Map<String, dynamic> payload, String token) async {
    await _dio.post(
      '/kyc/submit',
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<void> sendOtp({
    required String email,
    String purpose = 'registration',
  }) async {
    await _dio.post('/auth/otp/send', data: {
      'email': email,
      'purpose': purpose,
    });
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
    String purpose = 'registration',
  }) async {
    await _dio.post('/auth/otp/verify', data: {
      'email': email,
      'otp': otp,
      'purpose': purpose,
    });
  }
}

final onboardingRemoteDataSourceProvider =
    Provider<OnboardingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return OnboardingRemoteDataSource(dio);
});
