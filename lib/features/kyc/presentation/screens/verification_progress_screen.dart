import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/kyc_status_provider.dart';
import 'kyc_success_screen.dart';

class VerificationProgressScreen extends ConsumerWidget {
  const VerificationProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(kycStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.hourglass_top_rounded, color: AppColors.primary, size: 44),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Verification in Progress', style: AppTextStyles.heading, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "We've received your details. Most accounts are\nverified within a few hours - instant for Aadhaar e-KYC.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStep(
                        number: '1',
                        icon: Icons.check_circle,
                        iconColor: AppColors.success,
                        title: 'Application Submitted',
                        subtitle: 'Just now',
                        isDone: true,
                      ),
                      _buildConnector(),
                      _buildStep(
                        number: '2',
                        icon: statusAsync.value == 'approved' ? Icons.check_circle : null,
                        iconColor: AppColors.success,
                        title: 'KYC under review',
                        subtitle: statusAsync.when(
                          data: (status) => status == 'approved'
                              ? 'Verified'
                              : status == 'rejected'
                                  ? 'Rejected — please re-check documents'
                                  : 'Our team is verifying your documents',
                          loading: () => 'Checking status...',
                          error: (e, _) => 'Could not check status',
                        ),
                        isDone: statusAsync.value == 'approved',
                      ),
                      _buildConnector(),
                      _buildStep(
                        number: '3',
                        icon: statusAsync.value == 'approved' ? Icons.check_circle : null,
                        iconColor: AppColors.success,
                        title: 'Account creation',
                        subtitle: 'Happens automatically once approved',
                        isDone: statusAsync.value == 'approved',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (statusAsync.value == 'approved')
                  AppButton(
                    label: 'Continue',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const KycSuccessScreen()),
                      );
                    },
                  )
                else
                  AppButton(
                    label: 'Refresh status',
                    isLoading: statusAsync.isLoading,
                    onPressed: () => ref.refresh(kycStatusProvider),
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required IconData? icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDone,
  }) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isDone ? AppColors.success.withValues(alpha: 0.15) : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: isDone ? AppColors.success : AppColors.border),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, color: iconColor, size: 18)
                  : Text(number, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: Container(width: 1, height: 24, color: AppColors.border),
    );
  }
}