import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MpinRemoteDataSource {
  final Dio _dio;

  MpinRemoteDataSource(this._dio);

  Future<void> sendMpinResetOtp(String email) async {
    await _dio.post(
      '/auth/otp/send',
      data: {
        'email': email.trim(),
        'purpose': 'reset_mpin',
      },
    );
  }

  Future<void> resetMpin({
    required String email,
    required String otp,
    required String newMpin,
  }) async {
    await _dio.post(
      '/auth/mpin/reset',
      data: {
        'email': email.trim(),
        'otp': otp.trim(),
        'newMpin': newMpin.trim(),
      },
    );
  }

  Future<Map<String, dynamic>> loginWithMpin({
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
}

final mpinRemoteDataSourceProvider = Provider<MpinRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return MpinRemoteDataSource(dio);
});