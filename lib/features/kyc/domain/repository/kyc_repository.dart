import 'dart:io';

abstract class KycRepository {
  Future<void> uploadDocument(File file, String side);
  Future<void> submitKyc(Map<String, dynamic> payload);
  Future<String> fetchKycStatus();
}