import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<void> login({required String email, required String password}) async {
    await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
    });
  }

  Future<void> sendPasswordResetOtp(String email) async {
    await _dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    await _dio.post('/auth/verify-reset-otp', data: {
      'email': email,
      'otp': otp,
    });
  }

  Future<void> sendMobileOtp(String mobile) async {
    await _dio.post('/auth/send-mobile-otp', data: {'mobile': mobile});
  }

  Future<void> verifyMobileOtp({
    required String mobile,
    required String otp,
  }) async {
    await _dio.post('/auth/verify-mobile-otp', data: {
      'mobile': mobile,
      'otp': otp,
    });
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});