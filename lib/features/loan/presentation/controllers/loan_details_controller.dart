import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/loan_repository_impl.dart';
import '../../domain/entities/loan_details_entity.dart';

class LoanDetailsController extends AsyncNotifier<LoanDetailsEntity> {
  LoanDetailsController(this.loanId);

  final String loanId;

  @override
  FutureOr<LoanDetailsEntity> build() {
    return ref.watch(loanRepositoryProvider).fetchLoanDetails(loanId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final loanDetailsControllerProvider =
    AsyncNotifierProvider.family<
      LoanDetailsController,
      LoanDetailsEntity,
      String
    >(LoanDetailsController.new);
