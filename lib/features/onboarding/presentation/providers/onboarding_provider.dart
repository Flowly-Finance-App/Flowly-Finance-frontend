import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../controllers/onboarding_controller.dart';

final onboardingProvider = NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);