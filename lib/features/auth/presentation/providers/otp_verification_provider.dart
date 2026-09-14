import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/otp_verification_controller.dart';

final otpVerificationProvider = AsyncNotifierProvider<OtpVerificationController, void>(
  OtpVerificationController.new,
);