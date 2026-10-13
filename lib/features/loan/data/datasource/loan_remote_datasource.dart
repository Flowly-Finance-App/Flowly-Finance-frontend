import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';

class LoanRemoteDataSource {
  final Dio _dio;

  LoanRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> fetchLoanSummary() async {
    final response = await _dio.get('/customer/dashboard/active-loan');
    final data = response.data;

    if (data is Map) {
      final loan = data['loan'] ?? data['activeLoan'] ?? data['data'];

      if (loan is Map) {
        return Map<String, dynamic>.from(loan);
      }

      return Map<String, dynamic>.from(data);
    }

    throw Exception('Invalid active loan response');
  }

  Future<List<dynamic>> fetchLoanProducts() async {
    final response = await _dio.get('/loans/products');
    return _extractList(
      response.data,
      keys: const ['products', 'data'],
      errorMessage: 'Invalid loan products response',
    );
  }

  Future<List<dynamic>> fetchMyApplications() async {
    final response = await _dio.get('/loans/my-applications');
    return _extractList(
      response.data,
      keys: const ['applications', 'data'],
      errorMessage: 'Invalid loan applications response',
    );
  }

  Future<Map<String, dynamic>> fetchLoanDetails(String applicationId) async {
    final response = await _dio.get(
      '/loans/applications/${Uri.encodeComponent(applicationId)}',
    );

    final data = response.data;

    if (data is Map) {
      final application = data['application'];

      if (application is Map) {
        return Map<String, dynamic>.from(application);
      }

      return Map<String, dynamic>.from(data);
    }

    throw Exception('Invalid loan details response');
  }

  List<dynamic> _extractList(
    dynamic data, {
    required List<String> keys,
    required String errorMessage,
  }) {
    if (data is List) {
      return data;
    }

    if (data is Map) {
      for (final key in keys) {
        final value = data[key];

        if (value is List) {
          return value;
        }
      }
    }

    throw FormatException(errorMessage);
  }
}

final loanRemoteDataSourceProvider = Provider<LoanRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return LoanRemoteDataSource(dio);
});
