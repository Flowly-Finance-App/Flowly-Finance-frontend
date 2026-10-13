import 'dart:async';
import 'package:flowly_finance_app/features/onboarding/data/repository/otp_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationOtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(otpRepositoryProvider);
      await repo.sendOtp(email: email, purpose: 'registration');
    });
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(otpRepositoryProvider);
      await repo.verifyOtp(email: email, otp: otp, purpose: 'registration');
    });
  }
}