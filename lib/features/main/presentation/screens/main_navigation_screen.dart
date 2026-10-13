import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../loan/presentation/screens/my_loans_screen.dart';
import '../../../payments/presentation/screens/payments_screen.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../../../apply/presentation/screens/apply_loan_intro_screen.dart';
import '../providers/bottom_nav_provider.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const _tabs = [
    HomeScreen(),
    MyLoansScreen(),
    PaymentsScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ApplyLoanIntroScreen()),
            );
            return;
          }
          final tabIndex = index < 2 ? index : index - 1;
          ref.read(bottomNavIndexProvider.notifier).setIndex(tabIndex);
        },
      ),
    );
  }
}