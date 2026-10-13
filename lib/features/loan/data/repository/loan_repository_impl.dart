import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_details_entity.dart';
import '../../domain/entities/loan_summary_entity.dart';
import '../../domain/repository/loan_repository.dart';
import '../datasource/loan_remote_datasource.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanRemoteDataSource _remote;
  LoanRepositoryImpl(this._remote);

  @override
  Future<LoanSummaryEntity> fetchLoanSummary() async {
    final json = await _remote.fetchLoanSummary();
    return LoanSummaryEntity.fromJson(json);
  }

  @override
  Future<LoanDetailsEntity> fetchLoanDetails(String loanId) async {
    final json = await _remote.fetchLoanDetails(loanId);
    return LoanDetailsEntity.fromJson(json);
  }
}

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final remote = ref.watch(loanRemoteDataSourceProvider);
  return LoanRepositoryImpl(remote);
});
