import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/kyc_repository.dart';

final kycStatusProvider = FutureProvider.autoDispose<String>((ref) async {
  final repo = ref.watch(kycRepositoryProvider);
  return repo.fetchKycStatus();
});