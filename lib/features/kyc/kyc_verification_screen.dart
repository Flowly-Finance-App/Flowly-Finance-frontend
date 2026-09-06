import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../home/home_screen.dart';

enum KycStatus { pending, submitted, approved, rejected }

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  KycStatus _status = KycStatus.pending;
  bool _isSubmitting = false;

  void _handleSubmitKyc() {
    setState(() => _isSubmitting = true);

    // TODO Day 27: ഇവിടെ actual KYC Submit API call ചെയ്യണം
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
        _status = KycStatus.submitted;
      });
    });
  }

  void _handleGoToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // ഇത് navigation history മുഴുവൻ clear ചെയ്യുന്നു
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('KYC Status', style: AppTextStyles.subheading),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _status == KycStatus.pending
              ? _buildReviewView()
              : _buildStatusView(),
        ),
      ),
    );
  }

  // Status ഇപ്പോഴും "pending" ആണെങ്കിൽ — review + submit button കാണിക്കുന്നു
  Widget _buildReviewView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Your Details', style: AppTextStyles.heading),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Please confirm everything is correct before submitting',
            style: AppTextStyles.bodySecondary,
          ),

          const SizedBox(height: AppSpacing.xl),

          _buildReviewCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            items: const {
              'Name': 'Rahul Kumar',
              'Date of Birth': '15/06/1995',
              'Gender': 'Male',
            },
          ),

          const SizedBox(height: AppSpacing.md),

          _buildReviewCard(
            title: 'Documents',
            icon: Icons.badge_outlined,
            items: const {
              'Aadhaar Number': '1234 5678 9012',
              'PAN Number': 'ABCDE1234F',
              'Aadhaar Photo': 'Uploaded ✓',
              'PAN Photo': 'Uploaded ✓',
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          AppButton(
            label: 'Submit KYC',
            onPressed: _handleSubmitKyc,
            isLoading: _isSubmitting,
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String title,
    required IconData icon,
    required Map<String, String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTextStyles.subheading),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: AppTextStyles.bodySecondary),
                  Text(
                    entry.value,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Status "submitted"/"approved"/"rejected" ആയാൽ — status message കാണിക്കുന്നു
  Widget _buildStatusView() {
    IconData icon;
    Color color;
    String title;
    String message;

    switch (_status) {
      case KycStatus.submitted:
        icon = Icons.hourglass_top_rounded;
        color = AppColors.warning;
        title = 'KYC Under Review';
        message = 'Your documents have been submitted successfully.\n'
            'This usually takes 24-48 hours to verify.';
        break;
      case KycStatus.approved:
        icon = Icons.check_circle_outline;
        color = AppColors.success;
        title = 'KYC Approved!';
        message = 'Your identity has been verified successfully.\n'
            'You can now apply for loans.';
        break;
      case KycStatus.rejected:
        icon = Icons.cancel_outlined;
        color = AppColors.error;
        title = 'KYC Rejected';
        message = 'There was an issue verifying your documents.\n'
            'Please re-upload clearer images.';
        break;
      case KycStatus.pending:
        icon = Icons.hourglass_empty;
        color = AppColors.textSecondary;
        title = '';
        message = '';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 72),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.heading, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Go to Home',
              onPressed: _handleGoToHome,
            ),
          ),
        ],
      ),
    );
  }
}