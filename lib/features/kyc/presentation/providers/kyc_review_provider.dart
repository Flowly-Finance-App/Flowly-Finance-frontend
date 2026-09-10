import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kyc_form_provider.dart';
import 'document_upload_provider.dart';

final kycReviewSummaryProvider = Provider<Map<String, String>>((ref) {
  final form = ref.watch(kycFormProvider);
  final docAsync = ref.watch(documentUploadProvider);
  final doc = docAsync.value;

  String docTypeLabel(String? name) {
    switch (name) {
      case 'aadhaar':
        return 'Aadhaar card';
      case 'pan':
        return 'PAN card';
      case 'passport':
        return 'Passport';
      case 'drivingLicence':
        return 'Driving licence';
      default:
        return '-';
    }
  }

  return {
    'Name': form.name,
    'Date of birth': form.dob,
    'Mobile': form.mobile,
    'Email': form.email,
    'Address': form.address,
    'Branch': form.city,
    'Document type': docTypeLabel(doc?.docType.name),
    'Front & back': (doc?.frontImage != null) ? 'Uploaded' : 'Pending',
    'Selfie': (doc?.selfieImage != null) ? 'Captured' : 'Pending',
  };
});