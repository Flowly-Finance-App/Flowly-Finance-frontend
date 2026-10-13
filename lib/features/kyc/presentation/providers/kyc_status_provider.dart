import 'package:flowly_finance_app/features/kyc/data/repository/kyc_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kycStatusProvider = FutureProvider.autoDispose<String>((ref) async {
  final repo = ref.watch(kycRepositoryProvider);
  return repo.fetchKycStatus();
});