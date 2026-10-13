import 'dart:async';
import 'package:flowly_finance_app/features/apply/data/repository/apply_loan_repository_impl.dart';
import 'package:flowly_finance_app/features/apply/domain/entities/application_result_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/apply_loan_form_provider.dart';

class SubmitApplicationController extends AsyncNotifier<ApplicationResult?> {
  @override
  FutureOr<ApplicationResult?> build() => null;

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final form = ref.read(applyLoanFormProvider);
      final repo = ref.read(applyLoanRepositoryProvider);
      final result = await repo.submitApplication(form);
      return result;
    });
  }
}