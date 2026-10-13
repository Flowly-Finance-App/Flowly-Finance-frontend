import 'package:dio/dio.dart';
import 'package:flowly_finance_app/core/network/dio/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreRemoteDataSource {
  final Dio _dio;

  MoreRemoteDataSource(this._dio);

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}

final moreRemoteDataSourceProvider = Provider<MoreRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return MoreRemoteDataSource(dio);
});
