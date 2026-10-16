import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/kyc_repository.dart';
import '../datasource/kyc_remote_datasource.dart';

class KycRepositoryImpl implements KycRepository {
  final KycRemoteDataSource _remote;
  KycRepositoryImpl(this._remote);

  @override
  Future<void> submitKyc({
    required Map<String, String> fields,
    File? pan,
    File? aadhaar,
    File? selfie,
    File? document,
  }) {
    return _remote.submitKyc(
      fields: fields,
      pan: pan,
      aadhaar: aadhaar,
      selfie: selfie,
      document: document,
    );
  }

  @override
  Future<String> fetchKycStatus() async {
    final responseData = await _remote.fetchKycStatusRaw();

    if (responseData['status'] != null) {
      return responseData['status'].toString();
    }

    final data = responseData['data'];
    if (data is Map<String, dynamic> && data['status'] != null) {
      return data['status'].toString();
    }

    return 'pending';
  }
}

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  final remote = ref.watch(kycRemoteDataSourceProvider);
  return KycRepositoryImpl(remote);
});