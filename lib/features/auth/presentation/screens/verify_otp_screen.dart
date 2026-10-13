import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../onboarding/presentation/screens/create_mpin_screen.dart';
import '../providers/verify_otp_provider.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(verifyOtpProvider.notifier).sendOtp(widget.email);
      if (!mounted) return;

      final result = ref.read(verifyOtpProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.hasError
                ? 'Could not send OTP: ${result.error}'
                : 'OTP sent to ${widget.email}',
          ),
        ),
      );
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _enteredOtp =>
      _controllers.map((controller) => controller.text.trim()).join();

  Future<void> _handleVerify() async {
    if (_enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6-digit OTP')),
      );
      return;
    }

    await ref
        .read(verifyOtpProvider.notifier)
        .verify(email: widget.email, otp: _enteredOtp);

    final result = ref.read(verifyOtpProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${result.error}')),
      );
      return;
    }

    ref.read(onboardingProvider.notifier).updateOtp(_enteredOtp);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const CreateMpinScreen()),
    );
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0) return;

    await ref.read(verifyOtpProvider.notifier).sendOtp(widget.email);

    if (!mounted) return;

    final result = ref.read(verifyOtpProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.hasError
              ? 'Could not resend OTP: ${result.error}'
              : 'OTP resent',
        ),
      ),
    );

    _startResendTimer();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifyState = ref.watch(verifyOtpProvider);
    final isLoading = verifyState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
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
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Text('Verify OTP', style: AppTextStyles.heading),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Enter the 6 digit code sent to',
                  style: AppTextStyles.bodySecondary,
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(widget.email, style: AppTextStyles.subheading),

                const SizedBox(height: AppSpacing.xxl),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOtpBox(index)),
                ),

                const SizedBox(height: AppSpacing.lg),

                Center(
                  child: _secondsRemaining > 0
                      ? Text(
                          "Didn't Receive The OTP? Resend in $_secondsRemaining s",
                          style: AppTextStyles.bodySecondary,
                        )
                      : GestureDetector(
                          onTap: _handleResend,
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodySecondary,
                              children: [
                                const TextSpan(
                                  text: "Didn't Receive The OTP? ",
                                ),
                                TextSpan(
                                  text: 'Resend OTP',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                AppButton(
                  label: 'Verify & Proceed',
                  onPressed: _handleVerify,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: AppTextStyles.heading.copyWith(fontSize: 20, height: 1.0),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.length > 1) {
            final digits = value.replaceAll(RegExp(r'\D'), '');
            for (int i = 0; i < 6 && i < digits.length; i++) {
              _controllers[i].text = digits[i];
            }
            if (digits.length >= 6) {
              _focusNodes[5].requestFocus();
            } else {
              _focusNodes[digits.length].requestFocus();
            }
            return;
          }

          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
