import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void updateRegistration({required String fullName, required String email, required String phone}) {
    state = state.copyWith(fullName: fullName, email: email, phone: phone);
  }

  void updateOtp(String otp) => state = state.copyWith(otp: otp);

  void updateKyc({
    required String dob,
    required String gender,
    required String address,
    required String idType,
    required String idNumber,
    required String documentUrl,
  }) {
    state = state.copyWith(
      dob: dob,
      gender: gender,
      address: address,
      idType: idType,
      idNumber: idNumber,
      documentUrl: documentUrl,
    );
  }

  void updateMpin(String mpin) => state = state.copyWith(mpin: mpin);

  void reset() => state = const OnboardingState();
}