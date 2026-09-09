import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import 'verification_progress_screen.dart';

class ReviewSubmitScreen extends StatefulWidget {
  const ReviewSubmitScreen({super.key});

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  bool _isLoading = false;

  void _handleSubmit() {
    setState(() => _isLoading = true);

    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerificationProgressScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Review & Submit', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Details', style: AppTextStyles.subheading),
              const SizedBox(height: AppSpacing.sm),
              _buildInfoCard(const {
                'Name': 'Vishn Pillai',
                'Date of birth': '24/09/1999',
                'Mobile': '+919876543210',
                'Branch': 'Kochi',
              }),

              const SizedBox(height: AppSpacing.lg),

              Text('Identity Document', style: AppTextStyles.subheading),
              const SizedBox(height: AppSpacing.sm),
              _buildInfoCard(const {
                'Document type': 'Aadhar card',
                'Front & back': 'Uploaded',
                'Selfie': 'Captured',
              }, highlightValueColor: AppColors.success),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'By submitting, you consent to Flowly verifying these details with UIDI and your bureau record, in line with our KYC policy.',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Submit for Verification',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, String> items, {Color? highlightValueColor}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: AppTextStyles.bodySecondary),
                Text(
                  entry.value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: highlightValueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}