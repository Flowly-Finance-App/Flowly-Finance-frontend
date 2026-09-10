import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/kyc_models.dart';
import '../providers/document_upload_provider.dart';
import 'review_submit_screen.dart';

class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  String _docLabel(IdentityDocType type) {
    switch (type) {
      case IdentityDocType.aadhaar:
        return 'Aadhaar';
      case IdentityDocType.pan:
        return 'PAN';
      case IdentityDocType.passport:
        return 'Passport';
      case IdentityDocType.drivingLicence:
        return 'Driving licence';
    }
  }

  Future<void> _pickImage({required bool isFront, required bool isBack, required bool isSelfie}) async {
    ImageSource? source;

    if (isSelfie) {
      source = ImageSource.camera;
    } else {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('Select Image Source', style: AppTextStyles.subheading),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      );
    }

    if (source == null) return;

    final pickedFile = await _picker.pickImage(
      source: source,
      preferredCameraDevice: isSelfie ? CameraDevice.front : CameraDevice.rear,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final notifier = ref.read(documentUploadProvider.notifier);

    if (isFront) {
      notifier.setFrontImage(file);
    } else if (isBack) {
      notifier.setBackImage(file);
    } else if (isSelfie) {
      notifier.setSelfieImage(file);
    }
  }

  Future<void> _handleContinue() async {
    final doc = ref.read(documentUploadProvider).value;
    if (doc == null) return;

    final missingBack = doc.needsBackSide && doc.backImage == null;

    if (doc.frontImage == null || missingBack || doc.selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required uploads')),
      );
      return;
    }

    await ref.read(documentUploadProvider.notifier).uploadAll();

    final result = ref.read(documentUploadProvider);
    if (!mounted) return;

    if (result.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${result.error}')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ReviewSubmitScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docAsync = ref.watch(documentUploadProvider);
    final doc = docAsync.value ?? const DocumentUploadState();
    final isLoading = docAsync.isLoading;
    final label = _docLabel(doc.docType);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Upload documents', style: AppTextStyles.subheading),
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
              _buildUploadTile(
                title: '$label - front side',
                image: doc.frontImage,
                onTap: () => _pickImage(isFront: true, isBack: false, isSelfie: false),
                onRemove: () => ref.read(documentUploadProvider.notifier).removeFrontImage(),
                icon: Icons.badge_outlined,
              ),
              if (doc.needsBackSide) ...[
                const SizedBox(height: AppSpacing.md),
                _buildUploadTile(
                  title: '$label - back side',
                  image: doc.backImage,
                  onTap: () => _pickImage(isFront: false, isBack: true, isSelfie: false),
                  onRemove: () => ref.read(documentUploadProvider.notifier).removeBackImage(),
                  icon: Icons.badge_outlined,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _buildUploadTile(
                title: 'Live selfie',
                subtitleWhenEmpty: 'Tap to open camera',
                image: doc.selfieImage,
                onTap: () => _pickImage(isFront: false, isBack: false, isSelfie: true),
                onRemove: () => ref.read(documentUploadProvider.notifier).removeSelfieImage(),
                icon: Icons.camera_alt_outlined,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Make sure all four corners of the document are visible and text is readable. Your selfie is used only to match your face against the ID Photo.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Continue',
                onPressed: _handleContinue,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile({
    required String title,
    String? subtitleWhenEmpty,
    required File? image,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required IconData icon,
  }) {
    final isUploaded = image != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUploaded ? AppColors.success.withValues(alpha: 0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isUploaded ? AppColors.success.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          if (isUploaded)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.file(image, width: 44, height: 44, fit: BoxFit.cover),
            )
          else
            Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUploaded ? AppColors.success : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUploaded ? 'Uploaded — tap to replace' : (subtitleWhenEmpty ?? 'Tap to upload'),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
          if (isUploaded)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}