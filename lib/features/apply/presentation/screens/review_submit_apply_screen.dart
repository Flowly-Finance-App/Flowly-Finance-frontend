import 'package:flowly_finance_app/features/apply/domain/entities/loan_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/apply_loan_form_provider.dart';
import '../providers/submit_application_provider.dart';
import 'application_submitted_screen.dart';

class ReviewSubmitApplyScreen extends ConsumerStatefulWidget {
  const ReviewSubmitApplyScreen({super.key});

  @override
  ConsumerState<ReviewSubmitApplyScreen> createState() =>
      _ReviewSubmitApplyScreenState();
}

class _ReviewSubmitApplyScreenState
    extends ConsumerState<ReviewSubmitApplyScreen> {
  Future<void> _handleSubmit() async {
    final form = ref.read(applyLoanFormProvider);
    if (!form.agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm the details are correct')),
      );
      return;
    }

    await ref.read(submitApplicationProvider.notifier).submit();

    final result = ref.read(submitApplicationProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: ${result.error}')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ApplicationSubmittedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(applyLoanFormProvider);
    final submitState = ref.watch(submitApplicationProvider);
    final isSubmitting = submitState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Review & Submit', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _row('Loan Type', form.loanType.label),
                    const Divider(color: AppColors.border),
                    _row(
                      'Loan Amount',
                      '₹${form.loanAmount.toStringAsFixed(0)}',
                    ),
                    const Divider(color: AppColors.border),
                    _row('Loan Tenure', '${form.tenureMonths}Months'),
                    const Divider(color: AppColors.border),
                    _row(
                      'Interest Rate',
                      '${form.interestRate.toStringAsFixed(2)}% p.a.',
                    ),
                    const Divider(color: AppColors.border),
                    _row(
                      'EMI (Estimated)',
                      '₹${form.estimatedEmi.toStringAsFixed(0)}/month',
                    ),
                    const Divider(color: AppColors.border),
                    _row(
                      'Monthly Income',
                      '₹${form.monthlyIncome.isNotEmpty ? form.monthlyIncome : '-'}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: form.agreedToTerms,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        ref
                            .read(applyLoanFormProvider.notifier)
                            .updateAgreedToTerms(value ?? false);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'I hereby confirm that all the details provided by me are correct.',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Submit Application',
                onPressed: _handleSubmit,
                isLoading: isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(
            value,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
