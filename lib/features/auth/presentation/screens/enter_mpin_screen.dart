import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../main/presentation/screens/main_navigation_screen.dart';
import '../providers/enter_mpin_provider.dart';
import 'forgot_mpin_screen.dart';
 
class EnterMpinScreen extends ConsumerStatefulWidget {
  final String email;
 
  const EnterMpinScreen({super.key, required this.email});
 
  @override
  ConsumerState<EnterMpinScreen> createState() => _EnterMpinScreenState();
}
 
class _EnterMpinScreenState extends ConsumerState<EnterMpinScreen> {
  static const _pinLength = 4;
 
  final List<TextEditingController> _controllers = List.generate(
    _pinLength,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _pinLength,
    (index) => FocusNode(),
  );
 
  String get _enteredMpin => _controllers.map((c) => c.text).join();
 
  Future<void> _handleVerify() async {
    if (_enteredMpin.length != _pinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your $_pinLength-digit MPIN')),
      );
      return;
    }
 
    await ref
        .read(enterMpinProvider.notifier)
        .verify(email: widget.email, mpin: _enteredMpin);
 
    final result = ref.read(enterMpinProvider);
    if (!mounted) return;
 
    if (result.hasError || result.value == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect MPIN. Please try again.')),
      );
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
      return;
    }
 
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
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
    final verifyState = ref.watch(enterMpinProvider);
    final isLoading = verifyState.isLoading;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
 
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
 
              Text('Welcome back!', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your MPIN to continue',
                style: AppTextStyles.bodySecondary,
              ),
 
              const SizedBox(height: AppSpacing.xxl),
 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pinLength,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: _buildPinBox(index),
                  ),
                ),
              ),
 
              const SizedBox(height: AppSpacing.lg),
 
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgotMpinScreen(),
                    ),
                  );
                },
                child: Text(
                  'Forgot MPIN?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
 
              const SizedBox(height: AppSpacing.xl),
 
              AppButton(
                label: 'Unlock',
                onPressed: _handleVerify,
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
          if (index == _pinLength - 1 && value.isNotEmpty) {
            _handleVerify();
          }
        },
      ),
    );
  }
}