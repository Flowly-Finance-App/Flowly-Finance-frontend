import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/kyc_models.dart';

class KycFormController extends Notifier<KycFormState> {
  @override
  KycFormState build() => const KycFormState();

  void updateName(String value) => state = state.copyWith(name: value);
  void updateDob(String value) => state = state.copyWith(dob: value);
  void updateGender(String value) => state = state.copyWith(gender: value);
  void updateMobile(String value) => state = state.copyWith(mobile: value);
  void updateEmail(String value) => state = state.copyWith(email: value);
  void updateCity(String value) => state = state.copyWith(city: value);
  void updateAddress(String value) => state = state.copyWith(address: value);

  void saveDetails({
    required String name,
    required String dob,
    required String gender,
    required String mobile,
    required String email,
    required String city,
    required String address,
  }) {
    state = KycFormState(
      name: name,
      dob: dob,
      gender: gender,
      mobile: mobile,
      email: email,
      city: city,
      address: address,
    );
  }
}