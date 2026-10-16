import 'package:flowly_finance_app/features/kyc/presentation/screens/kyc_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/onboarding_provider.dart';
import '../providers/complete_registration_provider.dart';
import 'create_mpin_screen.dart';

class ConfirmMpinScreen extends ConsumerStatefulWidget {
  final String mpin;

  const ConfirmMpinScreen({super.key, required this.mpin});

  @override
  ConsumerState<ConfirmMpinScreen> createState() => _ConfirmMpinScreenState();
}

class _ConfirmMpinScreenState extends ConsumerState<ConfirmMpinScreen> {
  static const _pinLength = 4;

  final List<TextEditingController> _controllers =
      List.generate(_pinLength, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(_pinLength, (index) => FocusNode());

  String get _confirmedMpin => _controllers.map((c) => c.text.trim()).join();

  Future<void> _handleConfirm() async {
    if (_confirmedMpin.length != _pinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit MPIN')),
      );
      return;
    }

    if (_confirmedMpin != widget.mpin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MPINs do not match')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CreateMpinScreen()),
      );
      return;
    }

    ref.read(onboardingProvider.notifier).updateMpin(widget.mpin);

    await ref.read(completeRegistrationProvider.notifier).activateAccount();

    final result = ref.read(completeRegistrationProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account activation failed: ${result.error}')),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const KycIntroScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activationState = ref.watch(completeRegistrationProvider);
    final isLoading = activationState.isLoading;

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
          padding: const EdgeInsets.all(AppSpacing.lg),
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

              Text('Confirm MPIN', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Re-enter your MPIN to confirm',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xxl),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pinLength,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: _buildPinBox(index),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                label: 'Confirm & Activate Account',
                onPressed: _handleConfirm,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinBox(int index) {
    return SizedBox(
      width: 56,
      height: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        obscureText: true,
        obscuringCharacter: '●',
        maxLength: 1,
        style: AppTextStyles.heading,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < _pinLength - 1) {
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