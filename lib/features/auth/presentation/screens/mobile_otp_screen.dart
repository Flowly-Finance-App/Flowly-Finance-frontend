import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/mobile_otp_provider.dart';
import 'verify_otp_screen.dart';

class MobileOtpScreen extends ConsumerStatefulWidget {
  final String mobileNumber;

  const MobileOtpScreen({super.key, required this.mobileNumber});

  @override
  ConsumerState<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends ConsumerState<MobileOtpScreen> {
  Future<void> _handleGetOtp() async {
    await ref.read(mobileOtpProvider.notifier).sendOtp(widget.mobileNumber);

    final result = ref.read(mobileOtpProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send OTP: ${result.error}')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VerifyOtpScreen(mobileNumber: widget.mobileNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sendOtpState = ref.watch(mobileOtpProvider);
    final isLoading = sendOtpState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),

              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 40),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('OTP Verification', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We will send you a one-time password\nto this mobile number',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xxl),

              Text('Enter Mobile Number', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xs),
              Text(widget.mobileNumber, style: AppTextStyles.subheading),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                label: 'Get OTP',
                onPressed: _handleGetOtp,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}