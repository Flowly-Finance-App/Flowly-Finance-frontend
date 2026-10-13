import 'package:flowly_finance_app/features/apply/domain/entities/apply_loan_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/apply_loan_form_controller.dart';

final applyLoanFormProvider =
    NotifierProvider<ApplyLoanFormController, ApplyLoanFormState>(
  ApplyLoanFormController.new,
);