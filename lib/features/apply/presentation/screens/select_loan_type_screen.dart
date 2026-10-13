import 'package:flowly_finance_app/features/apply/domain/entities/loan_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/apply_loan_form_provider.dart';
import 'personal_details_apply_screen.dart';

class SelectLoanTypeScreen extends ConsumerWidget {
  const SelectLoanTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(applyLoanFormProvider).loanType;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Select Loan Type', style: AppTextStyles.subheading),
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
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: LoanType.values.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final type = LoanType.values[index];
                    final isSelected = type == selected;
                    return GestureDetector(
                      onTap: () => ref
                          .read(applyLoanFormProvider.notifier)
                          .updateLoanType(type),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                              ),
                              child: Icon(
                                _iconFor(type),
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type.label,
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    type.subtitle,
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Radio<LoanType>(
                              value: type,
                              groupValue: selected,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                if (value != null) {
                                  ref
                                      .read(applyLoanFormProvider.notifier)
                                      .updateLoanType(value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Proceed',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetailsApplyScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(LoanType type) {
    switch (type) {
      case LoanType.personal:
        return Icons.person_outline;
      case LoanType.home:
        return Icons.home_outlined;
      case LoanType.vehicle:
        return Icons.directions_car_outlined;
      case LoanType.education:
        return Icons.school_outlined;
      case LoanType.business:
        return Icons.trending_up_outlined;
    }
  }
}
