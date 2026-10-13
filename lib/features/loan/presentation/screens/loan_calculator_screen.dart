import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/loan_calculator_provider.dart';

class LoanCalculatorScreen extends ConsumerWidget {
  const LoanCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calc = ref.watch(loanCalculatorProvider);
    final notifier = ref.read(loanCalculatorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Loan Calculator', style: AppTextStyles.subheading),
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
              _sliderField(
                label: 'Loan Amount',
                valueLabel: '₹ ${calc.loanAmount.toStringAsFixed(0)}',
                value: calc.loanAmount,
                min: 10000,
                max: 2000000,
                onChanged: notifier.updateAmount,
              ),
              const SizedBox(height: AppSpacing.lg),
              _sliderField(
                label: 'Interest Rate (annual)',
                valueLabel: '${calc.interestRate.toStringAsFixed(1)}%',
                value: calc.interestRate,
                min: 1,
                max: 25,
                onChanged: notifier.updateInterestRate,
              ),
              const SizedBox(height: AppSpacing.lg),
              _sliderField(
                label: 'Tenure',
                valueLabel: '${calc.tenureMonths} months',
                value: calc.tenureMonths.toDouble(),
                min: 3,
                max: 360,
                onChanged: (v) => notifier.updateTenureMonths(v.round()),
              ),

              const SizedBox(height: AppSpacing.xl),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Column(
                  children: [
                    Text(
                      'Monthly EMI',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '₹ ${calc.emi.toStringAsFixed(2)}',
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryColumn('Total Interest', calc.totalInterest),
                        Container(width: 1, height: 36, color: Colors.white30),
                        _summaryColumn('Total Payable', calc.totalPayable),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sliderField({
    required String label,
    required String valueLabel,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body),
            Text(
              valueLabel,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _summaryColumn(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          '₹ ${value.toStringAsFixed(0)}',
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
