import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/payments_provider.dart';
import '../widgets/payment_tile.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Text('Payments', style: AppTextStyles.subheading),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(paymentsProvider.notifier).refresh(),
          child: paymentsAsync.when(
            loading: () => const LoadingIndicator(message: 'Loading payment history...'),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.payment_outlined, size: 56, color: AppColors.textSecondary),
                    const SizedBox(height: AppSpacing.md),
                    Text('Payments', style: AppTextStyles.heading),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Payment history and EMI payments — coming soon.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
            ),
            data: (payments) {
              if (payments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.payment_outlined, size: 56, color: AppColors.textSecondary),
                        const SizedBox(height: AppSpacing.md),
                        Text('No Payments Yet', style: AppTextStyles.heading),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Payment history and scheduled EMIs will appear here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  return PaymentTile(payment: payments[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}