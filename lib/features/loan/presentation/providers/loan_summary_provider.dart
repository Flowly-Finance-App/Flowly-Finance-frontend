import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loan_summary_entity.dart';
import '../controllers/loan_summary_controller.dart';

final loanSummaryProvider =
    AsyncNotifierProvider<LoanSummaryController, LoanSummaryEntity>(
  LoanSummaryController.new,
);