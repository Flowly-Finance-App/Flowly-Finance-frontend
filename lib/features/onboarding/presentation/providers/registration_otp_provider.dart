import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/registration_otp_controller.dart';

final registrationOtpProvider = AsyncNotifierProvider<RegistrationOtpController, void>(
  RegistrationOtpController.new,
);