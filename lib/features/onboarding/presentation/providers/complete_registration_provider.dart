import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/complete_registration_controller.dart';

final completeRegistrationProvider = AsyncNotifierProvider<CompleteRegistrationController, void>(
  CompleteRegistrationController.new,
);