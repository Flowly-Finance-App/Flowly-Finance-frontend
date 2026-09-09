import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import 'identity_verification_screen.dart';
import 'review_submit_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  final IdentityDocType docType;

  const DocumentUploadScreen({super.key, required this.docType});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  XFile? _frontImage;
  XFile? _backImage;
  XFile? _selfieImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

 
  String get _docLabel {
    switch (widget.docType) {
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


  bool get _needsBackSide => widget.docType != IdentityDocType.pan;

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

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = pickedFile;
        } else if (isBack) {
          _backImage = pickedFile;
        } else if (isSelfie) {
          _selfieImage = pickedFile;
        }
      });
    }
  }

  void _handleContinue() {
    final missingBack = _needsBackSide && _backImage == null;

    if (_frontImage == null || missingBack || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required uploads')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ReviewSubmitScreen()),
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
                title: '$_docLabel - front side',
                fileName: '${_docLabel.toLowerCase()}_front.jpg',
                image: _frontImage,
                onTap: () => _pickImage(isFront: true, isBack: false, isSelfie: false),
                icon: Icons.badge_outlined,
              ),

              if (_needsBackSide) ...[
                const SizedBox(height: AppSpacing.md),
                _buildUploadTile(
                  title: '$_docLabel - back side',
                  fileName: '${_docLabel.toLowerCase()}_back.jpg',
                  image: _backImage,
                  onTap: () => _pickImage(isFront: false, isBack: true, isSelfie: false),
                  icon: Icons.badge_outlined,
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              _buildUploadTile(
                title: 'Live selfie',
                fileName: null,
                subtitleWhenEmpty: 'Tap to open camera',
                image: _selfieImage,
                onTap: () => _pickImage(isFront: false, isBack: false, isSelfie: true),
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
                isLoading: _isLoading,
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
    required String? fileName,
    String? subtitleWhenEmpty,
    required XFile? image,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final isUploaded = image != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(
              isUploaded ? Icons.check_circle : icon,
              color: isUploaded ? AppColors.success : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
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
                    isUploaded ? '${fileName ?? "photo.jpg"} . uploaded' : (subtitleWhenEmpty ?? 'Tap to upload'),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}