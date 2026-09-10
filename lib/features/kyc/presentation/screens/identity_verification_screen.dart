import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/kyc_models.dart';
import '../providers/document_upload_provider.dart';
import 'document_upload_screen.dart';

class IdentityVerificationScreen extends ConsumerWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(documentUploadProvider);
    final selected = docAsync.value?.docType ?? IdentityDocType.aadhaar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Verify your identity', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a government ID to complete your KYC. This is matched against official records automatically',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildOption(
                ref: ref,
                selected: selected,
                type: IdentityDocType.aadhaar,
                icon: Icons.badge_outlined,
                title: 'Aadhaar card',
                subtitle: 'Instant e-KYC via UIDAI',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildOption(
                ref: ref,
                selected: selected,
                type: IdentityDocType.pan,
                icon: Icons.credit_card_outlined,
                title: 'PAN card',
                subtitle: 'Manual review, 1-2 business days',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildOption(
                ref: ref,
                selected: selected,
                type: IdentityDocType.passport,
                icon: Icons.menu_book_outlined,
                title: 'Passport',
                subtitle: 'Manual review, 1-2 business days',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildOption(
                ref: ref,
                selected: selected,
                type: IdentityDocType.drivingLicence,
                icon: Icons.directions_car_outlined,
                title: 'Driving licence',
                subtitle: 'Manual review, 1-2 business days',
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Continue',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const DocumentUploadScreen()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required WidgetRef ref,
    required IdentityDocType selected,
    required IdentityDocType type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = selected == type;

    return GestureDetector(
      onTap: () => ref.read(documentUploadProvider.notifier).setDocType(type),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Radio<IdentityDocType>(
              value: type,
              groupValue: selected,
              activeColor: AppColors.primary,
              onChanged: (value) {
                if (value != null) {
                  ref.read(documentUploadProvider.notifier).setDocType(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}