import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_session_storage.dart';
import '../../data/repository/onboarding_repository_impl.dart';
import '../providers/onboarding_provider.dart';

class CompleteRegistrationController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> activateAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final onboarding = ref.read(onboardingProvider);
      final repo = ref.read(onboardingRepositoryProvider);
      final token = await repo.register(onboarding);

      final storage = ref.read(secureSessionStorageProvider);
      await storage.saveToken(token);
      await storage.saveMpin(onboarding.mpin);
      await storage.markLoggedIn();
    });
  }
}
