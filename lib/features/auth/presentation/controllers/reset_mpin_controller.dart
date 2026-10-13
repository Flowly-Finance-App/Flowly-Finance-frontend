import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/mpin_repository_impl.dart';

class ResetMpinController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> reset({
    required String email,
    required String otp,
    required String newMpin,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(mpinRepositoryProvider);
      await repo.resetMpin(email: email, otp: otp, newMpin: newMpin);
    });
  }
}