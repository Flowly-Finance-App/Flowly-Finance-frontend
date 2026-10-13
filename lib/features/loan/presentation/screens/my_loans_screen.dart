import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_success_widget.dart';
import '../providers/loan_summary_provider.dart';
import 'loan_details_screen.dart';

class MyLoansScreen extends ConsumerStatefulWidget {
  const MyLoansScreen({super.key});

  @override
  ConsumerState<MyLoansScreen> createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends ConsumerState<MyLoansScreen> {
  bool _showActive = true;

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(loanSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            Icon(Icons.menu, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.md),
            Text('My Loans', style: AppTextStyles.subheading),
          ],
        ),
      ),
      body: SafeArea(
        child: summaryAsync.when(
          loading: () =>
              const LoadingIndicator(message: 'Loading your loans...'),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: MessageBanner(
              type: MessageType.error,
              message: 'Could not load loans: $error',
            ),
          ),
          data: (summary) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _tabButton(
                      'Active Loans',
                      _showActive,
                      () => setState(() => _showActive = true),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _tabButton(
                      'Closed Loans',
                      !_showActive,
                      () => setState(() => _showActive = false),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                if (_showActive) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Personal Loan',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                'Ongoing',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _row(
                          'Loan Amount',
                          '₹${summary.loanAmount.toStringAsFixed(0)}',
                        ),
                        _row(
                          'EMI Amount',
                          '₹${summary.emiAmount.toStringAsFixed(0)}',
                        ),
                        _row(
                          'Interest Rate',
                          '${summary.interestRate.toStringAsFixed(1)}%p.a.',
                        ),
                        _row(
                          'Next EMI Due',
                          summary.nextEmiDate.isNotEmpty
                              ? summary.nextEmiDate
                              : '-',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoanDetailsScreen(loanId: summary.loanId),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View Loan Details',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(
                      child: Text(
                        'No closed loans yet',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.xl),

                Text('Loan Summary', style: AppTextStyles.subheading),
                const SizedBox(height: AppSpacing.md),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: _DonutPainter(
                            activeAmount: summary.loanAmount,
                            closedAmount: 0,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total Loans', style: AppTextStyles.caption),
                            const SizedBox(height: 2),
                            Text(
                              '₹${summary.loanAmount.toStringAsFixed(0)}',
                              style: AppTextStyles.subheading,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legendDot(AppColors.primary, 'Active', summary.loanAmount),
                    const SizedBox(width: AppSpacing.xl),
                    _legendDot(AppColors.border, 'Closed', 0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 80,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySecondary),
          Text(
            value,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, double amount) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label  ₹${amount.toStringAsFixed(0)}',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double activeAmount;
  final double closedAmount;

  _DonutPainter({required this.activeAmount, required this.closedAmount});

  @override
  void paint(Canvas canvas, Size size) {
    final total = activeAmount + closedAmount;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final bgPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    if (total <= 0) return;

    final activeFraction = activeAmount / total;
    final activePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -1.5708,
      6.2832 * activeFraction,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.activeAmount != activeAmount ||
        oldDelegate.closedAmount != closedAmount;
  }
}
