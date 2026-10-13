import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowly_finance_app/features/auth/presentation/screens/forgot_mpin_screen.dart';
import 'package:flowly_finance_app/features/auth/presentation/screens/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../../main/presentation/screens/main_navigation_screen.dart';
import '../providers/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _pinLength = 4;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final List<TextEditingController> _mpinControllers = List.generate(
    _pinLength,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _mpinFocusNodes = List.generate(
    _pinLength,
    (index) => FocusNode(),
  );

  String get _enteredMpin => _mpinControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _emailController.dispose();

    for (final c in _mpinControllers) {
      c.dispose();
    }

    for (final f in _mpinFocusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_enteredMpin.length != _pinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your $_pinLength-digit MPIN')),
      );

      return;
    }

    await ref
        .read(loginProvider.notifier)
        .login(email: _emailController.text.trim(), mpin: _enteredMpin);

    final result = ref.read(loginProvider);

    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${result.error}')));

      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      (route) => false,
    );
  }

 Future<void> _handleGoogleSignIn() async {
  try {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google ID token was not received'),
        ),
      );

      return;
    }

    await ref.read(loginProvider.notifier).googleLogin(
          idToken: idToken,
          email: googleUser.email,
          name: googleUser.displayName,
          googleId: googleUser.id,
        );

    final result = ref.read(loginProvider);

    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Login failed: ${result.error}',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
      (route) => false,
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Google Sign-In failed: $e'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: AppSpacing.md),

                Center(
                  child: Image.asset(
                    'assets/images/flowly-image-png.png',
                    width: 200,
                    height: 200,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('Welcome Back!', style: AppTextStyles.heading),

                const SizedBox(height: AppSpacing.xs),

                Text('Login to continue', style: AppTextStyles.bodySecondary),

                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Email Address',
                  hintText: 'Enter Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('MPIN', style: AppTextStyles.body),

                const SizedBox(height: AppSpacing.sm),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _pinLength,
                    (index) => _buildMpinBox(index),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotMpinScreen(),
                        ),
                      );
                    },

                    child: Text(
                      'Forgot MPIN?',

                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                AppButton(
                  label: 'Login',
                  onPressed: _handleLogin,
                  isLoading: isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.divider)),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),

                      child: Text('OR', style: AppTextStyles.caption),
                    ),

                    const Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: _handleGoogleSignIn,

                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.divider),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                    ),

                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),

                    label: Text(
                      'Continue with Google',

                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.bodySecondary,
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },

                        child: Text(
                          'Register',

                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMpinBox(int index) {
    return SizedBox(
      width: 56,
      height: 60,

      child: TextField(
        controller: _mpinControllers[index],
        focusNode: _mpinFocusNodes[index],

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
            _mpinFocusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            _mpinFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
