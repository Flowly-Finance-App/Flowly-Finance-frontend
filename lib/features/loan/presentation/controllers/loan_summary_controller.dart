import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/loan_repository_impl.dart';
import '../../domain/entities/loan_summary_entity.dart';

class LoanSummaryController extends AsyncNotifier<LoanSummaryEntity> {
  @override
  FutureOr<LoanSummaryEntity> build() {
    return _fetch();
  }

  Future<LoanSummaryEntity> _fetch() {
    final repo = ref.read(loanRepositoryProvider);
    return repo.fetchLoanSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final loanSummaryControllerProvider =
    AsyncNotifierProvider<LoanSummaryController, LoanSummaryEntity>(
      LoanSummaryController.new,
    );
