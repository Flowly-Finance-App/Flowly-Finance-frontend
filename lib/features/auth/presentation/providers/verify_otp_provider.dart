import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/verify_otp_controller.dart';

final verifyOtpProvider = AsyncNotifierProvider<VerifyOtpController, void>(
  VerifyOtpController.new,
);