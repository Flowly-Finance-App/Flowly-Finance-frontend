import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Home Dashboard\n(Day 11-ൽ build ചെയ്യും)',
          textAlign: TextAlign.center,
          style: AppTextStyles.heading,
        ),
      ),
    );
  }
}