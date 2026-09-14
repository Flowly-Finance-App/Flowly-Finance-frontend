import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

class OtpVerificationController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> verify({required String email, required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.verifyPasswordResetOtp(email: email, otp: otp);
    });
  }
}