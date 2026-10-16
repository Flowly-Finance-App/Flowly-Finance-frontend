import 'dart:io';

abstract class KycRepository {
  Future<void> submitKyc({
    required Map<String, String> fields,
    File? pan,
    File? aadhaar,
    File? selfie,
    File? document,
  });

  Future<String> fetchKycStatus();
}