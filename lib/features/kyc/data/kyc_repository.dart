import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycRepository {
  final Dio _dio;
  KycRepository(this._dio);

  Future<void> uploadDocument(File file, String side) async {
    final formData = FormData.fromMap({
      'side': side,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });
    await _dio.post('/kyc/upload-document', data: formData);
  }

  Future<void> submitKyc(Map<String, dynamic> payload) async {
    await _dio.post('/kyc/submit', data: payload);
  }

  Future<String> fetchKycStatus() async {
    final response = await _dio.get('/kyc/status');
    return response.data['status'] ?? 'pending';
  }
}

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return KycRepository(dio);
});