import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/mpin_repository_impl.dart';

class ForgotMpinController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendOtp(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(mpinRepositoryProvider);
      await repo.sendMpinResetOtp(email);
    });
  }
}