import '../entities/loan_details_entity.dart';
import '../entities/loan_summary_entity.dart';

abstract class LoanRepository {
  Future<LoanSummaryEntity> fetchLoanSummary();
  Future<LoanDetailsEntity> fetchLoanDetails(String loanId);
}

