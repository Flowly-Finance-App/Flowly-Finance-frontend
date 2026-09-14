import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

class RegisterController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(name: name, email: email, mobile: mobile, password: password);
    });
  }
}