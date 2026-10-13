import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/otp_repository.dart';
import '../datasource/otp_remote_datasource.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource _remote;
  OtpRepositoryImpl(this._remote);

  @override
  Future<void> sendOtp({required String email, String purpose = 'registration'}) {
    return _remote.sendOtp(email: email, purpose: purpose);
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
    String purpose = 'registration',
  }) {
    return _remote.verifyOtp(email: email, otp: otp, purpose: purpose);
  }
}

final otpRepositoryProvider = Provider<OtpRepository>((ref) {
  final remote = ref.watch(otpRemoteDataSourceProvider);
  return OtpRepositoryImpl(remote);
});