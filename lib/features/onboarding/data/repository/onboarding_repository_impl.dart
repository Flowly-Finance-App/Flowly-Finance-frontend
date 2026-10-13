import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../domain/repository/onboarding_repository.dart';
import '../datasource/onboarding_remote_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource _remote;

  OnboardingRepositoryImpl(this._remote);

  @override
  Future<String> register(OnboardingState state) async {
    final payload = state.toRegisterJson();
    try {
      final data = await _remote.register(payload);
      if (data['token'] != null) return data['token'].toString();
      if (data['accessToken'] != null) return data['accessToken'].toString();
      if (data['data'] is Map) {
        final nested = data['data'] as Map;
        if (nested['token'] != null) return nested['token'].toString();
        if (nested['accessToken'] != null) return nested['accessToken'].toString();
      }
      return '';
    } on DioException catch (e) {
      final data = e.response?.data;
      String errorMsg = e.message ?? 'Registration failed';
      if (data is Map) {
        final msg = data['message'] ?? data['error'];
        if (msg != null) errorMsg = msg.toString();
      } else if (data is String && data.isNotEmpty) {
        errorMsg = data;
      }
      throw Exception(errorMsg);
    }
  }

  @override
  Future<void> submitKyc(OnboardingState state, String token) {
    return _remote.submitKyc(state.toKycJson(), token);
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final remote = ref.watch(onboardingRemoteDataSourceProvider);
  return OnboardingRepositoryImpl(remote);
});
