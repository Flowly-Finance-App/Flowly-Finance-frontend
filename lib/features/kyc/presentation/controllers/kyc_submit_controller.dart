import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/kyc_repository_impl.dart';
import '../../domain/entities/kyc_entity.dart';
import '../providers/document_upload_provider.dart';
import '../providers/kyc_form_provider.dart';

class KycSubmitController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final form = ref.read(kycFormProvider);
      final doc = ref.read(documentUploadProvider).value;

      if (doc == null || doc.frontImage == null || doc.selfieImage == null) {
        throw Exception('Please upload all required documents');
      }

      final fields = <String, String>{
        'address': form.address,
        'dob': form.dob,
        'gender': form.gender,
        'idType': doc.docType.name,
        'idNumber': form.idNumber,
        'panNumber': form.panNumber,
      };

      File? pan;
      File? aadhaar;
      File? document;

      switch (doc.docType) {
        case IdentityDocType.pan:
          pan = doc.frontImage;
          break;
        case IdentityDocType.aadhaar:
          aadhaar = doc.frontImage;
          document = doc.backImage; // back side: 'document' key (backend-il confirm cheyyuka)
          break;
        case IdentityDocType.passport:
        case IdentityDocType.drivingLicence:
          document = doc.frontImage;
          break;
      }

      final repo = ref.read(kycRepositoryProvider);
      await repo.submitKyc(
        fields: fields,
        pan: pan,
        aadhaar: aadhaar,
        selfie: doc.selfieImage,
        document: document,
      );
    });
  }
}