import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import 'kyc_screen.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),

                Image.asset('assets/images/flowly-image-png.png', width: 200, height: 200),

                const SizedBox(height: AppSpacing.lg),

                Text('Open Your Flowly Account', style: AppTextStyles.heading, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Takes about 4 minutes. You\'ll need a PAN or\nAadhaar and a selfie for e-KYC verification.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),

                const SizedBox(height: AppSpacing.xxl),

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
                      _buildStepRow('Personal Details', '30sec'),
                      const Divider(color: AppColors.border),
                      _buildStepRow('Identity Document', '1min'),
                      const Divider(color: AppColors.border),
                      _buildStepRow('Selfie Verification', '30sec'),
                      const Divider(color: AppColors.border),
                      _buildStepRow('Review & Submit', '1min'),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                AppButton(
                  label: 'Get Started',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const KycScreen()),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String title, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.body),
          Text(duration, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}