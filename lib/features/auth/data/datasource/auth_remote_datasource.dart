import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<void> sendEmailOtp({
    required String email,
    required String purpose,
  }) async {
    await _dio.post(
      '/auth/otp/send',
      data: {
        'email': email.trim(),
        'purpose': purpose,
      },
    );
  }

  Future<void> verifyEmailOtp({
    required String email,
    required String otp,
    required String purpose,
  }) async {
    await _dio.post(
      '/auth/otp/verify',
      data: {
        'email': email.trim(),
        'otp': otp.trim(),
        'purpose': purpose,
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String mpin,
  }) async {
    final response = await _dio.post(
      '/auth/user/login',
      data: {
        'email': email.trim(),
        'mpin': mpin.trim(),
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> googleLogin({
    required String idToken,
    String? email,
    String? name,
    String? googleId,
    String? phone,
  }) async {
    final response = await _dio.post(
      '/auth/google',
      data: {
        'idToken': idToken,
        if (email != null) 'email': email,
        if (name != null) 'name': name,
        if (googleId != null) 'googleId': googleId,
        if (phone != null) 'phone': phone,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/auth/me');

    return Map<String, dynamic>.from(response.data);
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio);
});