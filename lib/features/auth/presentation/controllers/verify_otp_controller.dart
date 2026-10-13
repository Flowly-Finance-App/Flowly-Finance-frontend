import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/auth_repository_impl.dart';

class VerifyOtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendOtp(String email) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      try {
        await repo.sendEmailOtp(email: email);
      } on DioException catch (e) {
        throw Exception(_serverMessage(e));
      }
    });
  }

  Future<void> verify({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      try {
        await repo.verifyEmailOtp(
          email: email,
          otp: otp,
        );
      } on DioException catch (e) {
        throw Exception(_serverMessage(e));
      }
    });
  }

  String _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'] ?? data['error'];
      if (msg != null) return msg.toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return e.message ?? 'Something went wrong';
  }
}