import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/forgot_mpin_controller.dart';

final forgotMpinProvider = AsyncNotifierProvider<ForgotMpinController, void>(
  ForgotMpinController.new,
);