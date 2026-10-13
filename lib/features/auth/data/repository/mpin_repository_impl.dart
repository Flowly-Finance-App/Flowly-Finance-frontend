import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repository/mpin_repository.dart';
import '../datasource/mpin_remote_datasource.dart';

class MpinRepositoryImpl implements MpinRepository {
  final MpinRemoteDataSource _remote;

  MpinRepositoryImpl(this._remote);

  @override
  Future<void> sendMpinResetOtp(String email) {
    return _remote.sendMpinResetOtp(email);
  }

  @override
  Future<void> resetMpin({
    required String email,
    required String otp,
    required String newMpin,
  }) {
    return _remote.resetMpin(email: email, otp: otp, newMpin: newMpin);
  }

  @override
  Future<AuthSessionEntity> loginWithMpin({
    required String email,
    required String mpin,
  }) async {
    final json = await _remote.loginWithMpin(email: email, mpin: mpin);
    return AuthSessionEntity.fromJson(json);
  }
}

final mpinRepositoryProvider = Provider<MpinRepository>((ref) {
  final remote = ref.watch(mpinRemoteDataSourceProvider);
  return MpinRepositoryImpl(remote);
});