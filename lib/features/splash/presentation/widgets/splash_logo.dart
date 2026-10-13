import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/flowly-image-png.png',
          width: 200,
          height: 200,
        ),
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
    );
  }
}
