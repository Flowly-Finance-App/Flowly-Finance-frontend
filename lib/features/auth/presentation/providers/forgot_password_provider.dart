import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/forgot_password_controller.dart';

final forgotPasswordProvider = AsyncNotifierProvider<ForgotPasswordController, void>(
  ForgotPasswordController.new,
);