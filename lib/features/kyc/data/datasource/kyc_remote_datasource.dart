import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycRemoteDataSource {
  final Dio _dio;
  KycRemoteDataSource(this._dio);

  /// POST /api/kyc/submit (multipart/form-data)
  Future<void> submitKyc({
    required Map<String, String> fields,
    File? pan,
    File? aadhaar,
    File? selfie,
    File? document,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (pan != null) 'pan': await _file(pan),
      if (aadhaar != null) 'aadhaar': await _file(aadhaar),
      if (selfie != null) 'selfie': await _file(selfie),
      if (document != null) 'document': await _file(document),
    });

    await _dio.post(
      '/kyc/submit',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<Map<String, dynamic>> fetchKycStatusRaw() async {
    final response = await _dio.get('/kyc/status');
    final data = response.data;
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<MultipartFile> _file(File file) {
    final name = file.path.split('/').last;
    return MultipartFile.fromFile(file.path, filename: name);
  }
}

final kycRemoteDataSourceProvider = Provider<KycRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return KycRemoteDataSource(dio);
});