import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/apply_loan_form_provider.dart';
import 'review_submit_apply_screen.dart';

class LoanAmountScreen extends ConsumerStatefulWidget {
  const LoanAmountScreen({super.key});

  @override
  ConsumerState<LoanAmountScreen> createState() => _LoanAmountScreenState();
}

class _LoanAmountScreenState extends ConsumerState<LoanAmountScreen> {
  static const _amountOptions = [
    50000.0,
    100000.0,
    150000.0,
    200000.0,
    250000.0,
    300000.0,
    400000.0,
    500000.0,
  ];

  double? _selectedAmount;

  @override
  void initState() {
    super.initState();
    _selectedAmount = ref.read(applyLoanFormProvider).loanAmount;
  }

  void _handleNext() {
    if (_selectedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a loan amount')),
      );
      return;
    }

    ref.read(applyLoanFormProvider.notifier).updateLoanAmount(_selectedAmount!);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ReviewSubmitApplyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Loan Details', style: AppTextStyles.subheading),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan Amount', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.separated(
                    itemCount: _amountOptions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final amount = _amountOptions[index];
                      final isSelected = amount == _selectedAmount;
                      return ListTile(
                        title: Text(
                          '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppColors.primary)
                            : null,
                        onTap: () => setState(() => _selectedAmount = amount),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Next', onPressed: _handleNext),
            ],
          ),
        ),
      ),
    );
  }
}
