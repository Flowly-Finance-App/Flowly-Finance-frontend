import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<String> register(OnboardingState state);
  Future<void> submitKyc(OnboardingState state, String token);
}