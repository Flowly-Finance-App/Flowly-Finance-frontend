import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycRemoteDataSource {
  final Dio _dio;
  KycRemoteDataSource(this._dio);

  Future<void> uploadDocument(File file, String side) async {
    throw UnimplementedError(
      'Document upload API is not available in the current backend documentation.',
    );
  }

  Future<void> submitKyc(Map<String, dynamic> payload) async {
    await _dio.post('/kyc/submit', data: payload);
  }

  Future<Map<String, dynamic>> fetchKycStatusRaw() async {
    final response = await _dio.get('/kyc/status');
    final data = response.data;
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }
}

final kycRemoteDataSourceProvider = Provider<KycRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return KycRemoteDataSource(dio);
});