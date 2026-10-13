import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_success_widget.dart';
import '../providers/loan_summary_provider.dart';
import 'loan_details_screen.dart';

class LoanSummaryScreen extends ConsumerWidget {
  final bool showBackButton;

  const LoanSummaryScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(loanSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Loan Summary', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
      ),
      body: SafeArea(
        child: summaryAsync.when(
          loading: () => const LoadingIndicator(message: 'Loading loan summary...'),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: MessageBanner(
              type: MessageType.error,
              message: 'Could not load loan summary: $error',
            ),
          ),
          data: (summary) => SingleChildScrollView(
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
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _row('Loan Amount', '₹ ${summary.loanAmount.toStringAsFixed(2)}'),
                      const Divider(color: AppColors.divider),
                      _row(
                        'Outstanding Amount',
                        '₹ ${summary.outstandingAmount.toStringAsFixed(2)}',
                        valueColor: AppColors.error,
                      ),
                      const Divider(color: AppColors.divider),
                      _row('EMI Amount', '₹ ${summary.emiAmount.toStringAsFixed(2)}'),
                      const Divider(color: AppColors.divider),
                      _row('Interest Rate', '${summary.interestRate.toStringAsFixed(2)}%'),
                      const Divider(color: AppColors.divider),
                      _row('Tenure', '${summary.tenureMonths} months'),
                      const Divider(color: AppColors.divider),
                      _row(
                        'Next EMI Date',
                        summary.nextEmiDate.isNotEmpty ? summary.nextEmiDate : '-',
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'View Full Details',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoanDetailsScreen(loanId: summary.loanId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}