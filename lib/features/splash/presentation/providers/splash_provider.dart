import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/splash_controller.dart';

export '../controllers/splash_controller.dart';

final splashProvider =
    AsyncNotifierProvider<SplashController, SplashNavigationTarget>(
  SplashController.new,
);
