import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsRemoteDataSource {
  final Dio _dio;

  PaymentsRemoteDataSource(this._dio);

  Future<List<Map<String, dynamic>>> fetchPaymentHistory() async {
    final response = await _dio.get('/payments/history');
    final data = response.data;
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> makePayment({
    required String loanId,
    required double amount,
  }) async {
    final response = await _dio.post(
      '/payments/pay',
      data: {'loanId': loanId, 'amount': amount},
    );
    return Map<String, dynamic>.from(response.data);
  }
}

final paymentsRemoteDataSourceProvider =
    Provider<PaymentsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PaymentsRemoteDataSource(dio);
});
