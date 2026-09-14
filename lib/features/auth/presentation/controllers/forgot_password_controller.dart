import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPasswordResetOtp(email);
    });
  }
}