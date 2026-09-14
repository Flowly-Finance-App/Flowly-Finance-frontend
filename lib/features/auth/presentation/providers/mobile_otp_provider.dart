import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/mobile_otp_controller.dart';

final mobileOtpProvider = AsyncNotifierProvider<MobileOtpController, void>(
  MobileOtpController.new,
);