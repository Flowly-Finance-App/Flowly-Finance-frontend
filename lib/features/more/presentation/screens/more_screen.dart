import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../kyc/presentation/screens/kyc_screen.dart';
import '../providers/more_provider.dart';
import '../widgets/more_menu_tile.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(moreMenuProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text('More', style: AppTextStyles.subheading),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ...menuItems.map((item) {
              return MoreMenuTile(
                item: item,
                onTap: () {
                  if (item.id == 'kyc') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const KycScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.title} — coming soon')),
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}