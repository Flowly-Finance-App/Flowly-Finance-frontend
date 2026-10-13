import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/fd_calculator_provider.dart';

class FdCalculatorScreen extends ConsumerWidget {
  const FdCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calc = ref.watch(fdCalculatorProvider);
    final notifier = ref.read(fdCalculatorProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('FD Calculator', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
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
                label: 'Deposit Amount',
                valueLabel: '₹ ${calc.depositAmount.toStringAsFixed(0)}',
                value: calc.depositAmount,
                min: 5000,
                max: 5000000,
                onChanged: notifier.updateDepositAmount,
              ),
              const SizedBox(height: AppSpacing.lg),
              _sliderField(
                label: 'Interest Rate (annual)',
                valueLabel: '${calc.interestRate.toStringAsFixed(1)}%',
                value: calc.interestRate,
                min: 3,
                max: 12,
                onChanged: notifier.updateInterestRate,
              ),
              const SizedBox(height: AppSpacing.lg),
              _sliderField(
                label: 'Tenure',
                valueLabel: '${calc.tenureYears} years',
                value: calc.tenureYears.toDouble(),
                min: 1,
                max: 10,
                onChanged: (v) => notifier.updateTenureYears(v.round()),
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
                      'Maturity Amount',
                      style: AppTextStyles.caption.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '₹ ${calc.maturityAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Total Interest Earned: ₹ ${calc.totalInterest.toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),
              Text(
                'Interest compounded quarterly, as per standard bank FD rules.',
                style: AppTextStyles.caption,
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
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
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
}