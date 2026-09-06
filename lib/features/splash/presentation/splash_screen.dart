import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // 2.5 seconds splash-ന് ശേഷം navigate ചെയ്യുക
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // TODO Day 6/27: ഇവിടെ actual authentication status check ചെയ്യണം
    // (secure storage-ൽ token ഉണ്ടോ എന്ന് നോക്കി Login/Home തീരുമാനിക്കണം)
    final bool isLoggedIn = false; // temporary hardcoded value

    if (isLoggedIn) {
      // Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } else {
      // Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/flowly-image-png.png',
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 24),
              Text(
                'Flowly',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                'Simple. Secure. Reliable.',
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}