import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyLoanRemoteDataSource {
  final Dio _dio;

  ApplyLoanRemoteDataSource(this._dio); 

  Future<Map<String, dynamic>> submitApplication(
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post('/loans/apply', data: payload);

    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }
    return {};
  }

  Future<List<dynamic>> getMyApplications() async {
    final response = await _dio.get('/loans/my-applications');

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final applications = data['applications'];
      if (applications is List) {
        return applications;
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> resubmitDocuments({
    required String applicationId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post(
      '/loans/applications/$applicationId/resubmit-documents',
      data: data,
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> acceptSanction({
    required String applicationId,
  }) async {
    final response = await _dio.post(
      '/loans/applications/$applicationId/accept-sanction',
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> esignLoan({
    required String applicationId,
    required String signatureHash,
  }) async {
    final response = await _dio.post(
      '/loans/applications/$applicationId/esign',
      data: {'signatureHash': signatureHash},
    );
    return Map<String, dynamic>.from(response.data);
  }
}

final applyLoanRemoteDataSourceProvider =
    Provider<ApplyLoanRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ApplyLoanRemoteDataSource(dio);
});