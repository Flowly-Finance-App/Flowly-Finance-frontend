// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../data/repository/auth_repository_impl.dart';
// import '../../../../core/storage/secure_session_storage.dart';

// class LoginController extends AsyncNotifier<void> {
//   @override
//   FutureOr<void> build() {}

//   // Normal MPIN Login
//   Future<void> login({
//     required String email,
//     required String mpin,
//   }) async {
//     state = const AsyncLoading();

//     state = await AsyncValue.guard(() async {
//       final repo = ref.read(authRepositoryProvider);

//       final session = await repo.login(
//         email: email,
//         mpin: mpin,
//       );

//       final storage = ref.read(secureSessionStorageProvider);

//       await storage.saveToken(session.token);
//       await storage.markLoggedIn();
//     });
//   }

//   // Google Login
//   Future<void> googleLogin({
//     required String idToken,
//     String? email,
//     String? name,
//     String? googleId,
//     String? phone,
//   }) async {
//     state = const AsyncLoading();

//     state = await AsyncValue.guard(() async {
//       final repo = ref.read(authRepositoryProvider);

//       final session = await repo.googleLogin(
//         idToken: idToken,
//         email: email,
//         name: name,
//         googleId: googleId,
//         phone: phone,
//       );

//       final storage = ref.read(secureSessionStorageProvider);

//       await storage.saveToken(session.token);
//       await storage.markLoggedIn();
//     });
//   }
// }

import 'dart:async';

import 'package:flowly_finance_app/core/storage/secure_session_storage.dart';
import 'package:flowly_finance_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> login({
    required String email,
    required String mpin,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      final session = await repo.login(
        email: email,
        mpin: mpin,
      );

      final storage = ref.read(secureSessionStorageProvider);

      await storage.saveToken(session.token);
      await storage.markLoggedIn();
    });
  }

  Future<void> googleLogin({
    required String idToken,
    String? email,
    String? name,
    String? googleId,
    String? phone,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      final session = await repo.googleLogin(
        idToken: idToken,
        email: email,
        name: name,
        googleId: googleId,
        phone: phone,
      );

      final storage = ref.read(secureSessionStorageProvider);

      await storage.saveToken(session.token);
      await storage.markLoggedIn();
    });
  }
}