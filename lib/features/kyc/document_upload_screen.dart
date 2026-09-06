import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import 'ocr_result_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  XFile? _aadhaarImage;
  XFile? _panImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isAadhaar) async {
    final source = await showModalBottomSheet<ImageSource>(
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

    if (source == null) return;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        if (isAadhaar) {
          _aadhaarImage = pickedFile;
        } else {
          _panImage = pickedFile;
        }
      });
    }
  }

  void _removeImage(bool isAadhaar) {
    setState(() {
      if (isAadhaar) {
        _aadhaarImage = null;
      } else {
        _panImage = null;
      }
    });
  }

  void _handleContinue() {
    if (_aadhaarImage == null || _panImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both Aadhaar and PAN documents')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO Day 27: ഇവിടെ actual document upload API call ചെയ്യണം
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const OcrResultScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Upload Documents', style: AppTextStyles.subheading),
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
              Text('Document Verification', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Upload clear photos of your Aadhaar and PAN card',
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xl),

              _buildUploadCard(
                title: 'Aadhaar Card',
                subtitle: 'Front side of your Aadhaar',
                image: _aadhaarImage,
                onUpload: () => _pickImage(true),
                onRemove: () => _removeImage(true),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildUploadCard(
                title: 'PAN Card',
                subtitle: 'Front side of your PAN card',
                image: _panImage,
                onUpload: () => _pickImage(false),
                onRemove: () => _removeImage(false),
              ),

              const SizedBox(height: AppSpacing.xl),

              AppButton(
                label: 'Continue',
                onPressed: _handleContinue,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required XFile? image,
    required VoidCallback onUpload,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),

          if (image == null)
            GestureDetector(
              onTap: onUpload,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 36),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap to upload',
                      style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: kIsWeb
                      ? Image.network(image.path, height: 160, width: double.infinity, fit: BoxFit.cover)
                      : Image.file(File(image.path), height: 160, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onUpload,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Re-upload'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                        label: const Text('Remove', style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}