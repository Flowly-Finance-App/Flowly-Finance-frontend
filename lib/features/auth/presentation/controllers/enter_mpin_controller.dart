import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/mpin_repository_impl.dart';

class EnterMpinController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() => false;

  Future<void> verify({required String email, required String mpin}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(mpinRepositoryProvider);
      await repo.loginWithMpin(email: email, mpin: mpin);
      return true;
    });
  }
}