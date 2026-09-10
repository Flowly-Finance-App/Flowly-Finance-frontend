import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/kyc_repository.dart';
import '../providers/kyc_form_provider.dart';
import '../providers/document_upload_provider.dart';

class KycSubmitController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // No initial async work needed.
  }

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final form = ref.read(kycFormProvider);
      final doc = ref.read(documentUploadProvider).value;

      final payload = {
        'name': form.name,
        'dob': form.dob,
        'gender': form.gender,
        'mobile': form.mobile,
        'email': form.email,
        'city': form.city,
        'address': form.address,
        'documentType': doc?.docType.name,
      };

      final repo = ref.read(kycRepositoryProvider);
      await repo.submitKyc(payload);
    });
  }
}