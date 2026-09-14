import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/login_controller.dart';

final loginProvider = AsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);