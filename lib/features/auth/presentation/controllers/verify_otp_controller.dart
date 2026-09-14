import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

class VerifyOtpController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> verify({required String mobile, required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.verifyMobileOtp(mobile: mobile, otp: otp);
    });
  }
}