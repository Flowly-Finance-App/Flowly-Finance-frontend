import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/forgot_mpin_provider.dart';
import '../providers/reset_mpin_provider.dart';
import 'enter_mpin_screen.dart';

class ResetMpinScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetMpinScreen({super.key, required this.email});

  @override
  ConsumerState<ResetMpinScreen> createState() => _ResetMpinScreenState();
}

class _ResetMpinScreenState extends ConsumerState<ResetMpinScreen> {
  static const _otpLength = 6;
  static const _pinLength = 4;

  final List<TextEditingController> _otpControllers = List.generate(
    _otpLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    _otpLength,
    (index) => FocusNode(),
  );

  final List<TextEditingController> _pinControllers = List.generate(
    _pinLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _pinFocusNodes = List.generate(
    _pinLength,
    (index) => FocusNode(),
  );

  final List<TextEditingController> _confirmPinControllers = List.generate(
    _pinLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _confirmPinFocusNodes = List.generate(
    _pinLength,
    (index) => FocusNode(),
  );

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();
  String get _newMpin => _pinControllers.map((c) => c.text).join();
  String get _confirmMpin => _confirmPinControllers.map((c) => c.text).join();

  Future<void> _handleReset() async {
    if (_enteredOtp.length != _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6-digit OTP')),
      );
      return;
    }
    if (_newMpin.length != _pinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a $_pinLength-digit MPIN')),
      );
      return;
    }
    if (_newMpin != _confirmMpin) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('MPINs do not match')));
      return;
    }

    await ref
        .read(resetMpinProvider.notifier)
        .reset(email: widget.email, otp: _enteredOtp, newMpin: _newMpin);

    final result = ref.read(resetMpinProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reset failed: ${result.error}')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('MPIN reset successful')));
   Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => EnterMpinScreen(email: widget.email)),
  (route) => false,
); 
  }

  Future<void> _handleResendOtp() async {
    await ref.read(forgotMpinProvider.notifier).sendOtp(widget.email);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP resent')));
  }

  @override
  void dispose() {
    for (final c in [
      ..._otpControllers,
      ..._pinControllers,
      ..._confirmPinControllers,
    ]) {
      c.dispose();
    }
    for (final f in [
      ..._otpFocusNodes,
      ..._pinFocusNodes,
      ..._confirmPinFocusNodes,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetMpinProvider);
    final isLoading = resetState.isLoading;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset MPIN', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter the OTP sent to\n${widget.email}',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('OTP', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _otpLength,
                  (i) =>
                      _digitBox(_otpControllers, _otpFocusNodes, i, width: 44),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleResendOtp,
                  child: Text(
                    'Resend OTP',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('New MPIN', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pinLength,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: _digitBox(
                      _pinControllers,
                      _pinFocusNodes,
                      i,
                      obscure: true,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Confirm New MPIN', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pinLength,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: _digitBox(
                      _confirmPinControllers,
                      _confirmPinFocusNodes,
                      i,
                      obscure: true,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Reset MPIN',
                onPressed: _handleReset,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _digitBox(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
    int index, {
    double width = 48,
    bool obscure = false,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        obscureText: obscure,
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
          if (value.isNotEmpty && index < controllers.length - 1) {
            focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
