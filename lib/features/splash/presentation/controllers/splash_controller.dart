import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_session_storage.dart';

enum SplashNavigationTarget { login, main }

class SplashController extends AsyncNotifier<SplashNavigationTarget> {
  @override
  FutureOr<SplashNavigationTarget> build() async {
    final storage = ref.read(secureSessionStorageProvider);
    final isLoggedOut = await storage.isLoggedOut();
    return isLoggedOut
        ? SplashNavigationTarget.login
        : SplashNavigationTarget.main;
  }
}
