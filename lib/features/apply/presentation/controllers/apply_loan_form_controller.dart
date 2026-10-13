import 'package:flowly_finance_app/features/apply/domain/entities/apply_loan_form_state.dart';
import 'package:flowly_finance_app/features/apply/domain/entities/loan_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplyLoanFormController extends Notifier<ApplyLoanFormState> {
  @override
  ApplyLoanFormState build() => const ApplyLoanFormState();
  
  void updateLoanType(LoanType type) => state = state.copyWith(loanType: type);

  void updatePersonalDetails({
    required String fullName,
    required String mobile,
    required String email,
    required String dob,
    required String panNumber,
  }) {
    state = state.copyWith(
      fullName: fullName,
      mobile: mobile,
      email: email,
      dob: dob,
      panNumber: panNumber,
    );
  }

  void updateEmploymentDetails({
    required String employmentType,
    required String monthlyIncome,
    required String companyName,
    required String workExperience,
  }) {
    state = state.copyWith(
      employmentType: employmentType,
      monthlyIncome: monthlyIncome,
      companyName: companyName,
      workExperience: workExperience,
    );
  }

  void updateLoanAmount(double amount) =>
      state = state.copyWith(loanAmount: amount);

  void updateAgreedToTerms(bool value) =>
      state = state.copyWith(agreedToTerms: value);

  void reset() => state = const ApplyLoanFormState();
}
